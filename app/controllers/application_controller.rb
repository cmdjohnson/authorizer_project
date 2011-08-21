# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  ##############################################################################
  # authorizer
  ##############################################################################

  require 'authorizer/exceptions'

  rescue_from Authorizer::UserNotAuthorized do |exception|
    # Show a static 403 page upon authorization failure
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end

  ##############################################################################
  # end authorizer
  ##############################################################################

  helper :all

  helper_method :current_user_session, :current_user

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
end

