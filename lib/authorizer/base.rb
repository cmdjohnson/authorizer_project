# -*- encoding : utf-8 -*-
################################################################################
# Authorizer
#
# Authorizer is a Ruby class that authorizes using the ObjectRole record.
################################################################################
module Authorizer
  class Base < ApplicationController
    ############################################################################
    # authorize_user
    #
    # If no user is specified, authorizes the current user.
    # If no role is specified, "owner" is used as role.
    ############################################################################

    def self.authorize_user(options)
      OptionsChecker.check(options, [ :object ])

      ret = false

      object = options[:object]
      role = options[:role] || "owner"
      user = options[:user] || get_current_user

      return false if basic_check_fails?(options)

      klazz_name = object.class.to_s
      object_reference = object.id

      unless user.nil?
        or_ = ObjectRole.first( :conditions => { :klazz_name => klazz_name, :object_reference => object_reference, :user_id => user.id } )
      end

      # This time, we want it to be nil.
      if or_.nil? && !user.nil?
        ObjectRole.create!( :klazz_name => klazz_name, :object_reference => object_reference, :user => user, :role => role )
        Rails.logger.debug("Authorizer: created authorization on #{object} for current_user with ID #{user.id} witih role #{role}")
        ret = true
      end

      ret
    end

    ############################################################################
    # user_is_authorized?
    #
    # If no user is specified, current_user is used.
    ############################################################################

    def self.user_is_authorized? options
      OptionsChecker.check(options, [ :object ])

      ret = false

      check = basic_check_fails?(options)
      return ret if check

      object = options[:object]
      user = options[:user] || get_current_user
      klazz_name = object.class.to_s
      object_reference = object.id

      unless user.nil?
        or_ = ObjectRole.first( :conditions => { :klazz_name => klazz_name, :object_reference => object_reference, :user_id => user.id } )
      end

      # Congratulations, you've been Authorized.
      unless or_.nil?
        ret = true
      end

      if ret
        Rails.logger.debug("Authorizer: authorized current_user with ID #{user.id} to access #{or_.description} because of role #{or_.role}")
      else
        Rails.logger.debug("Authorizer: authorization failed for current_user with ID #{user.id} to access #{object.to_s}")
      end

      ret
    end

    ############################################################################
    # is_authorized?
    #
    # Checks if the corresponding role.eql?("owner")
    ############################################################################

    def self.is_authorized? object
      user_is_authorized? :object => object
    end

    ############################################################################
    # create_ownership
    #
    # ObjectRole.create!( :klazz_name => object.class.to_s, :object_reference => object.id, :user => current_user, :role => "owner" )
    ############################################################################

    def self.create_ownership object
      ret = false

      return ret if basic_check_fails?(object)

      ret = authorize_user( :object => object )

      ret
    end

    ############################################################################
    # create_brand_new_object_roles
    #
    # For if you've been working without Authorizer and want to start using it.
    # Obviously, if you don't have any ObjectRoles then you'll find yourself blocked out of your own app.
    # This method will assign all objects listed in an array to a certain user.
    # For instance:
    #
    # user = User.find(1)
    # objects = [ "Post", "Category" ]
    # Authorizer.create_brand_new_object_roles( :user => user, :objects => objects )
    ############################################################################

    def self.create_brand_new_object_roles(options = {})
      OptionsChecker.check(options, [ :user, :objects ])

      objects = options[:objects]

      current_user_id = get_current_user.id

      unless current_user_id.nil?
        for object in objects
          evaled_klazz = nil

          begin
            evaled_klazz = eval(object)
          rescue
          end

          unless evaled_klazz.nil?
            # Let's find all. This is the same as Post.all
            if evaled_klazz.is_a?(Class)
              collection = evaled_klazz.all

              # Go
              unless collection.blank?
                for coll_ in collection
                  ObjectRole.create!( :klazz_name => object, :object_reference => coll_.id, :user_id => current_user_id, :role => "owner" )
                end
              end
            end
          end
        end
      end
    end

    protected

    def self.basic_check_fails?(options)
      ret = false

      unless options[:object].nil?
        if !options[:object].is_a?(ActiveRecord::Base) || options[:object].new_record?
          raise "object must be subclass of ActiveRecord::Base and must also be saved."
        end
      end

      unless options[:user].nil?
        raise "User object must be saved" if !options[:user].is_a?(ActiveRecord::Base) || options[:user].new_record?
      end

      ret
    end

    def self.get_current_user
      ret = nil

      begin
        session = UserSession.find
        ret = session.user
      rescue
      end

      ret
    end
  end
end