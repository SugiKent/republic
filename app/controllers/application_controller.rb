class ApplicationController < ActionController::Base
  # stagingだけBasic認証
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == 'staging'
  # protect_from_forgery with: :exception
  after_action :store_location
  before_action :set_format

  def set_format
    Thread.current[:format] = request[:format]
  end

  def store_location
    if request.fullpath !~ Regexp.new('\\A/users/.*\\z') &&
       !request.xhr? # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(_resource)
    session[:previous_url]
  end

  unless Rails.env.development?
    protect_from_forgery with: :exception
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from Exception, with: :render_500
  end

  def render_404(exception)
    ExceptionNotifier.notify_exception(exception, env: request.env, data: { message: 'error' })
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render template: 'errors/error_404', status: 404, layout: 'application'
  end

  def render_500(exception)
    ExceptionNotifier.notify_exception(exception, env: request.env, data: { message: 'error' })
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render template: 'errors/error_404', status: 500, layout: 'application'
  end

  def set_notifications
    # Ajaxの場合実行しない
    return false if request.xhr?
    if user_signed_in?
      @notifications = ActivityLog.set_notifications(current_user).sort_by(&:created_at).reverse!
    end
  end

  private

  # TODO: Basic認証はもう使ってない
  def basic_auth
    authenticate_or_request_with_http_basic do |user, pass|
      user == ENV["RIKKYO_APP_BASIC_NAME"] && pass == ENV["RIKKYO_APP_BASIC_PASSWORD"]
    end
  end
end
