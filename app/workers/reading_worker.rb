class ReadingWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(new_reading_hash)
    new_reading = Reading.new(new_reading_hash)
    puts "Sidekiq worker creating new reading"
    if new_reading.save
    else
      puts errors: new_reading.errors
    end
  end
end
