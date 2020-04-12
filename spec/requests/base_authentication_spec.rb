RSpec.describe 'Base API Authentication', type: :request do
  context 'when the user provides a valid API token' do
    let(:thermostat) { FactoryBot.create(:thermostat, :reading_here) }
    it 'authenticates the request and allows him to access a reading endpoint' do
      reading = thermostat.readings.first
      household_token = thermostat.household_token

      get "/api/v1/readings/#{reading.id}", headers: {"HTTP_AUTHORIZATION": "Token token=#{household_token}", "ACCEPT": "application/json"}
      
      expect(response).to be_successful
      expect(response.body).to include(reading.to_json)
    end
  end
end

