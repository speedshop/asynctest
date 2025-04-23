require 'concurrent'
require 'net/http'

module Parallel
  class Base
    @@executor = Concurrent::ThreadPoolExecutor.new(min_threads: 0, max_threads: 5, max_queue: 0)
    def self.executor = @@executor
    def add_work(args) = (@work ||= []) << args

    def fetch_all
      futures = @work.map { |args| Concurrent::Future.execute(executor: self.class.executor) { fetch(args) } }
      futures.each(&:wait)
      futures.each { |f| raise f.reason if f.rejected? }
      futures.map(&:value)
    end
  end

  class HTTP < Base
    def fetch(args) = Net::HTTP.get(URI(args[:url]))
  end
end
