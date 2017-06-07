class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :better_errors_hack, if: -> { Rails.env.development? }

  def better_errors_hack
    request.env['puma.config'].options.user_options.delete :app
  end

  def default_url_options
    { host: ENV["HOST"] || "localhost:3000" }
  end
end
