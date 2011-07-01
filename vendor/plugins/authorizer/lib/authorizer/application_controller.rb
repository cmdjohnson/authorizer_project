# -*- encoding : utf-8 -*-
# Use this file to add a couple of helper methods to ApplicationController

################################################################################
# Addendum to ApplicationController
################################################################################
# These methods are heavily dependent on InheritedResources, more specifically the 'resource' method.
#
# Otherwise there would be no predefined way of peeking into a controller's resource object.
################################################################################

# for user_not_authorized
require 'authorizer/exceptions'

class ApplicationController < ActionController::Base
  helper_method :own_created_object, :authorize

  private

  ##############################################################################
  # authorizer
  ##############################################################################

  def own_created_object
    ret = true # always return true otherwise the filter chain would be blocked.

    unless resource.nil?
      Authorizer::Base.authorize_user( :object => resource )
    end

    ret
  end

  def authorize
    ret = false # return false by default, effectively using a whitelist method.

    unless resource.nil?
      auth = Authorizer::Base.user_is_authorized?( :object => resource )

      if auth.eql?(false)
        raise Authorizer::UserNotAuthorized.new("You are not authorized to access this resource.")
      end
    end

    ret
  end

  ##############################################################################
  # end authorizer
  ##############################################################################
end
