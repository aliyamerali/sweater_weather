class Roadtrip
  attr_reader :origin, :destination, :duration

  def initialize(origin, destination, duration)
    @origin = origin
    @destination = destination
    @duration = format_duration(duration)
  end

  def format_duration(duration)
    "#{duration[:hours]} hours, #{duration[:minutes]} minutes"
  end
end
