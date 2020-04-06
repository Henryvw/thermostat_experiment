class Thermostat < ApplicationRecord
  has_many :readings

  def assemble_stats(start, stop)
    households_readings = self.readings
    all_stats_in_timeframe = households_readings.time_frame(start, stop).find_all_measurements
  end
end
