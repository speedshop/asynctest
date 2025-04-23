require "async"
require "net/http"
require "async/semaphore"

module Parallel
  class Base
    @@semaphore = Async::Semaphore.new(5)
    def self.semaphore = @@semaphore

    def add_work(args) = (@work ||= []) << args

    def fetch_all
      Sync do
        @work.map { |args| self.class.semaphore.async { fetch(args) } }.map(&:wait) # TODO: parent: barrier? does that make sense?
      end
    end
  end

  class HTTP < Base
    def fetch(args) = Net::HTTP.get(URI(args[:url]))
  end
end
