module Service
  class ImporterStationStatus
    attr_reader :attributes

    # attributes:
    #  {
    #    :lat              => "param",
    #    :long             => "param",
    #    :title            => "param",
    #    :bikesampa_id     => "param",
    #    :online_status    => "param",
    #    :operation_status => "param",
    #    :busy_positions   => "param",
    #    :total_bikes      => "param",
    #    :address          => "param",
    #    :status           => "param"
    #  }
    def initialize(attributes)
      @attributes = attributes
    end

    def self.save(attributes)
      self.new(attributes).save!
    end

    def save!
      station = find_or_create_station
      create_new_status(station)
    end

    private
    def find_or_create_station
      station = Station.find_by_bikesampa_id(attributes[:bikesampa_id])

      station || Station.create(
        :lat          => attributes[:lat],
        :long         => attributes[:long],
        :title        => attributes[:title],
        :bikesampa_id => attributes[:bikesampa_id],
        :total_bikes  => attributes[:total_bikes],
        :address      => attributes[:address]
      )
    end

    def create_new_status(station)
      StationStatus.create(
        :online_status => attributes[:online_status],
        :operation_status => attributes[:operation_status],
        :status => attributes[:status],
        :busy_positions => attributes[:busy_positions],
      )
    end
  end
end
