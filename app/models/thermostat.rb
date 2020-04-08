class Thermostat < ApplicationRecord
  has_many :readings

  before_create :set_auth_household_token

  def assemble_stats(start, stop)
    households_readings = self.readings
    all_stats_in_timeframe = households_readings.time_frame(start, stop).find_all_measurements
  end

  private
  def set_auth_household_token
    return if household_token.present?
    self.household_token = generate_household_token
  end

  def generate_household_token
    SecureRandom.uuid.gsub(/\-/,'')
  end
end
