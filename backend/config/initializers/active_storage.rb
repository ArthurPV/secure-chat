Rails.application.config.to_prepare do
  ActiveStorage::Current.url_options = {
    host: Rails.application.config.action_mailer.default_url_options[:host],
    port: Rails.application.config.action_mailer.default_url_options[:port],
    protocol: Rails.env.production? ? "https" : "http"
  }
end
