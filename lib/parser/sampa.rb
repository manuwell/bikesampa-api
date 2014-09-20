module Parser
  class Sampa
    MAINTENANCE = 'EM'
    DEPLOYMENT  = 'EI'
    OPERATING   = 'EO'
    ONLINE      = 'A'
    OFFLINE     = 'I'

    attr_reader :text

    def initialize(text)
      @text = text
    end

    def self.parse(text)
      self.new(text).extract
    end

    def extract
      text_points.each do |p|
        Service::ImporterStationStatus.save(build_station(p))
      end
    end

    private
    def text_points
      text.scan(/\nexibirEstacaMapa\((.+?)\);/m)
    end

    def build_station(string_point)
      string_point = string_point[0].gsub(/[\n\r\\"]*/,'')
      point_attributes = string_point.split(',')

      online_status = point_attributes.fetch(5)
      operation_status = point_attributes.fetch(6)

      {
        :lat              => point_attributes.fetch(0),
        :long             => point_attributes.fetch(1),
        :title            => point_attributes.fetch(3),
        :bikesampa_id     => point_attributes.fetch(4),
        :online_status    => friendly_online(online_status),
        :operation_status => friendly_operation(operation_status),
        :busy_positions   => point_attributes.fetch(7),
        :total_bikes      => point_attributes.fetch(8),
        :address          => point_attributes.fetch(9),
        :status           => friendly_status(operation_status, online_status)
      }
    end

    def friendly_operation(status)
      if status == DEPLOYMENT
        'deployment'
      elsif status == MAINTENANCE
        'maintenance'
      elsif status == OPERATING
        'operating'
      else
        'unknow'
      end
    end

    def friendly_online(status)
      if status == ONLINE
        'online'
      elsif status == OFFLINE
        'offline'
      else
        'unknow'
      end
    end

    def friendly_status(operation_status, online_status)
      if(operation_status == DEPLOYMENT) || (operation_status == MAINTENANCE)
        "deploy_or_maintenance"
      else
        if (online_status == ONLINE && operation_status == OPERATING )
          "in_operation";
        else
          "offline";
        end
      end
    end
  end
end

