require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  let(:thermostat) { FactoryBot.create(:thermostat, :reading_here) }
  let(:reading) {thermostat.readings.first}

  it 'finds and returns a specific reading associated with it' do
    expect(thermostat.readings.find(id=reading.id)).to eq(reading)
  end

  it 'returns its location' do
    thermostat.location = "44 Riviera Street"
    expect(thermostat.location).to eq("44 Riviera Street")
  end

  it 'generates and returns a household_token' do
    allow(SecureRandom).to receive(:uuid).and_return('6b8b6c369061498786818825d49ebf06')
    new_thermostat = FactoryBot.create(:thermostat)
    expect(new_thermostat.household_token).to eq ('6b8b6c369061498786818825d49ebf06')
  end

  context 'when it receives a specific time frame' do
    it 'asks its readings to return the relevant stats' do
      start_time = reading.created_at - 10.days
      end_time = reading.created_at + 10.days

       stats_hash = {
          "avg_battery_charge" => 0.5e2,
          "avg_humidity" => 0.2e2,
          "avg_temperature" => 0.2e2,
          "max_battery_charge" => 50.0,
          "max_humidity" => 20.0,
          "max_temperature" => 20.0,
          "min_battery_charge" => 50.0,
          "min_humidity" => 20.0,
          "min_temperature" => 20.0
       }

      expect(thermostat.assemble_stats(start_time, end_time)).to eq(stats_hash)
    end
  end
end
