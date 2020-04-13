require 'rails_helper'

RSpec.describe 'Base API Authentication', type: :request do
  context 'when the user provides a valid API token' do
    let(:thermostat) { FactoryBot.create(:thermostat, :reading_here) }
    it 'authenticates the GET reading request and allows him to access a reading endpoint' do
      reading = thermostat.readings.first
      household_token = thermostat.household_token

      get "/api/v1/readings/#{reading.id}", headers: {"HTTP_AUTHORIZATION": "Token token=#{household_token}", "ACCEPT": "application/json"}

      expect(response).to be_successful
      expect(response.body).to include(reading.to_json)
    end

    it 'authenticates the GET thermostat statistics request and allows him to access a thermostat endpoint' do
      reading = thermostat.readings.first
      household_token = thermostat.household_token

      t_start = reading.created_at - 10.days
      t_end = reading.created_at + 10.days
      get "/api/v1/thermostats/#{thermostat.id}?start=#{t_start}&end=#{t_end}", headers: {"HTTP_AUTHORIZATION": "Token token=#{household_token}", "ACCEPT": "application/json"}

      expect(response).to be_successful
      expect(response.body).to include(thermostat.assemble_stats(t_start, t_end).to_json)
    end

    it 'authenticates a POST reading request and allows it to POST a new reading' do
      reading = thermostat.readings.first
      household_token = thermostat.household_token

      post "/api/v1/readings/?thermostat_id=#{thermostat.id}&humidity=100&battery_charge=100&temperature=100", headers: {"HTTP_AUTHORIZATION": "Token token=#{household_token}", "ACCEPT": "application/json"}

      expect(response).to have_http_status :accepted
    end
  end

  context 'When the user provides an invalid API token' do
    let(:thermostat) { FactoryBot.create(:thermostat, :reading_here) }

    it 'does not allow the user to access the GET reading endpoint' do
      reading = thermostat.readings.first

      get "/api/v1/readings/#{reading.id}", headers: {"HTTP_AUTHORIZATION": "Token token=wrong_token", "ACCEPT": "application/json"}

      expect(response).to have_http_status :unauthorized
    end

    it 'does not allow the user to access the GET thermostat statistics request' do
      reading = thermostat.readings.first
      t_start = reading.created_at - 10.days
      t_end = reading.created_at + 10.days

      get "/api/v1/thermostats/#{thermostat.id}?start=#{t_start}&end=#{t_end}", headers: {"HTTP_AUTHORIZATION": "Token token=wrong_token", "ACCEPT": "application/json"}

      expect(response).to have_http_status :unauthorized
    end

    it 'does not allow the user to access the POST reading request' do
      reading = thermostat.readings.first

      post "/api/v1/readings/", headers: {"HTTP_AUTHORIZATION": "Token token=wrong_token", "ACCEPT": "application/json"}

      expect(response).to have_http_status :unauthorized
    end
  end 
end
