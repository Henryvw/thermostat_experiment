require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:thermostat) { FactoryBot.create(:thermostat, :reading_here) }
  let(:reading) {thermostat.readings.first}

  describe 'Attributes - Classic ActiveRecord Instance Methods' do
    it 'returns the thermostat its associated with' do
      my_thermostat = FactoryBot.create(:thermostat)
      reading.thermostat = my_thermostat
      expect(reading.thermostat).to eq my_thermostat
    end

    it 'returns its temperature' do
      reading.temperature = 45
      expect(reading.temperature).to eq 45
    end

    it 'returns its humidity' do
      reading.humidity = 60
      expect(reading.humidity).to eq 60
    end

    it 'returns its battery charge' do
      reading.battery_charge = 80
      expect(reading.battery_charge).to eq 80
    end

    it 'returns its sequence id' do
      new_reading = FactoryBot.create(:reading, thermostat_id: thermostat.id)
      new_reading.sequential_id = 400
      expect(new_reading.sequential_id).to eq 400
    end

    it 'auto generates a sequence id' do
      a_second_reading = FactoryBot.create(:reading, thermostat_id: thermostat.id)
      expect(a_second_reading.sequential_id).to eq 2
    end

    it 'starts generating a new sequence on a new thermostat' do
      new_thermostat = FactoryBot.create(:thermostat)
      new_thermostat_reading = FactoryBot.create(:reading, thermostat_id: new_thermostat.id)
      expect(new_thermostat_reading.sequential_id).to eq 1
    end
  end

  context 'when it receives a time frame and stats request from a thermostat' do
    let(:min_reading) { FactoryBot.create(:reading, thermostat: thermostat, humidity: 0, battery_charge: 0, temperature: 0)}
    let(:max_reading) {FactoryBot.create(:reading, thermostat: thermostat, humidity: 100, battery_charge: 100, temperature: 100)}

    it 'returns readings from the given timeframe (::time_frame)' do
      an_old_reading = FactoryBot.create(:reading, thermostat: thermostat, created_at: DateTime.now - 20.years)
      start_time = an_old_reading.created_at - 10.days
      end_time = an_old_reading.created_at + 10.days

      expect(Reading.time_frame(start_time, end_time)).to include(an_old_reading)
    end

    it 'returns a minimum temperature' do
      min_reading
      expect(Reading.find_min("temperature")).to eq (0)
    end

    it 'returns a maximum temperature' do
      max_reading
      expect(Reading.find_max("temperature")).to eq (100)
    end

    it 'returns an average temperature' do
      min_reading
      max_reading
      expect(Reading.find_average("temperature")).to eq (0.4e2)
    end

    it 'returns a minimum humidity' do
      min_reading
      expect(Reading.find_min("humidity")).to eq (0)
    end

    it 'returns a max humidity' do
      max_reading
      expect(Reading.find_max("humidity")).to eq (100)
    end

    it 'returns an average humidity' do
      min_reading
      max_reading
      expect(Reading.find_average("humidity")).to eq (0.4e2)
    end

    it 'returns a min battery charge' do
      min_reading
      expect(Reading.find_min("battery_charge")).to eq (0)
    end

    it 'returns a max battery charge' do
      max_reading
      expect(Reading.find_max("battery_charge")).to eq (100)
    end

    it 'returns an average battery charge' do
      min_reading
      max_reading
      expect(Reading.find_average("battery_charge")).to eq (0.5e2)
    end

    it 'returns a full battery of stats (::find_all_measurements)' do
      min_reading
      max_reading
      stats_hash = {
        "avg_battery_charge" => 0.5e2,
        "avg_humidity" => 0.4e2,
        "avg_temperature" => 0.4e2,
        "max_battery_charge" => 100.0,
        "max_humidity" => 100.0,
        "max_temperature" => 100.0,
        "min_battery_charge" => 0.0,
        "min_humidity" => 0.0,
        "min_temperature" => 0.0
      }
      expect(Reading.find_all_measurements).to eq (stats_hash)
    end
  end
end
