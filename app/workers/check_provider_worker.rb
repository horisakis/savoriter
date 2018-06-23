class CheckProviderWorker
  include Sidekiq::Worker

  def perform(*_args)
    # Do something
    Favorite.check_and_save_provider_all
  end

end
