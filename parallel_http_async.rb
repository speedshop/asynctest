require 'async'
require 'async/http/internet'

module Parallel
  class Base

    def self.semaphore
      @semaphore ||= Async::Semaphore.new(5)
    end

    def add_work(args)
      @work ||= []
      @work << args
    end

    def fetch_all
      Async do
        @work.map do |args|
          self.class.semaphore.async do
            fetch(args)
          end
        end.map(&:wait)
      end.wait
    end
  end

  class HTTP < Base
    def fetch(args)
      internet = Async::HTTP::Internet.new
      internet.get(args[:url]).read
    end
  end
end
