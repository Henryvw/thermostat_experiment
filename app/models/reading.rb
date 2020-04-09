class Reading < ApplicationRecord
  belongs_to :thermostat
  acts_as_sequenced scope: :thermostat_id

  def self.time_frame(start, stop)
    Reading.where(created_at: start..stop)
  end

  def self.find_min(scientific_measurement)
    Reading.minimum(scientific_measurement.to_sym)
  end

  def self.find_max(scientific_measurement)
    Reading.maximum(scientific_measurement.to_sym)
  end

  def self.find_average(scientific_measurement)
    Reading.average(scientific_measurement.to_sym)
  end

  def self.find_all_measurements
    measurement_types = ["temperature", "humidity", "battery_charge"]
    stats = {}
    measurement_types.each do |measurement|
      stats["min_" + measurement] = Reading.find_min(measurement)
      stats["max_" + measurement] = Reading.find_max(measurement)
      stats["avg_" + measurement] = Reading.find_average(measurement)
    end

    stats
  end
end
