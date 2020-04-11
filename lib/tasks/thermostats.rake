namespace :thermostats do
  desc "Seed Readings for Thermostats"
  task seed_readings: :environment do
    Rake::Task["db:seed"].invoke
  end
end
