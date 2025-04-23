require 'async'
require 'net/http'
require 'async/semaphore'
require 'async/barrier'

module Parallel
  class Base
    @@semaphore = Async::Semaphore.new(5)
    def self.semaphore = @@semaphore
    def add_work(args) = (@work ||= []) << args

    def fetch_all
      barrier = Async::Barrier.new
      Sync do
        @work.map { |args| self.class.semaphore.async(parent: barrier) { fetch(args) } }.map(&:wait) # TODO: parent: barrier? does that make sense?
      ensure
        barrier.stop
      end
    end
  end

  class HTTP < Base
    def fetch(args) = Net::HTTP.get(URI(args[:url]))
  end
end
