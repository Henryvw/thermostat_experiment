FactoryBot.define do
  factory :reading do
    thermostat_id {}
    temperature {20}
    battery_charge {50}
    humidity {20}
  end
end
