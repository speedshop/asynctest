require 'async'
require 'async/http/internet'

module ParallelHttp
  class Base
    def add_work(args)
      @work ||= []
      @work << args
    end

    def fetch_all
      Sync do |parent|
        work.map do |args|
          parent.async do
            fetch(args)
          end
        end.map(&:wait)
      end
    end
  end
end

module ParallelHttp
  class FreshdeskTicketIds < ParallelHttp::Base
    def fetch(args)
      Sync do
        ticket_service = Freshdesk::FetchTicketIds.new(args[:email], args[:service_entity_code])
        ticket_service.call
      end
    end
  end

  class FreshdeskTicketAttachments < ParallelHttp::Base
    def fetch(args)
      Sync do
        response = ::Freshdesk::FetchTicket.call(ticket_details: {ticket_id: args[:ticket_id], service_entity_code: args[:service_entity_code]})
        response[:data][:attachments]
      end
    end
  end
end


urls = Array.new(3) do
	'https://api.open-meteo.com/v1/forecast?latitude=35.5923&longitude=139.6654&daily=weather_code&models=best_match&timezone=Asia%2FTokyo&forecast_days=1'
end

parallel_service = ParallelHttp::FreshdeskTicketIds.new
parallel_service.add_work(email: 'test@test.com', service_entity_code: '123456')
parallel_service.add_work(email: 'test@test.com', service_entity_code: '123456')
parallel_service.fetch_all
