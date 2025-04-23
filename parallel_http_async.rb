require 'async'
require 'async/http/internet'

module Parallel
  class Base
    def add_work(args)
      @work ||= []
      @work << args
    end

    def fetch_all
      Sync do |parent|
        @work.map do |args|
          parent.async do
            fetch(args)
          end
        end.map(&:wait)
      end
    end
  end

  class HTTP < Base
    def fetch(args)
      Sync do
        internet = Async::HTTP::Internet.new
		    internet.get(args[:url]).read
      end
    end
  end
end
