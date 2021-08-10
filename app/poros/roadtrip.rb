class Roadtrip
  attr_reader :origin, :destination, :duration

  def initialize(origin, destination, duration)
    @origin = origin
    @destination = destination
    @duration = format_duration(duration)
  end

  def format_duration(duration)
    if duration.is_a?(Hash)
      "#{duration[:hours]} hours, #{duration[:minutes]} minutes"
    else
      duration
    end
  end
end
