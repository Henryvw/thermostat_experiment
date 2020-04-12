FactoryBot.define do
  factory :thermostat do
    location {"Goethestrasse 1840"}
  end

  trait :reading_here do
    after(:create) do |thermostat|
      thermostat.readings << create(:reading, thermostat_id: thermostat.id) 
    end 
  end
end

