# -*- encoding : utf-8 -*-
class Authorizer
  ##############################################################################
  # Authorizer
  #
  # Authorizer is a Ruby class that authorizes using the ObjectRole record.
  ##############################################################################

  ##############################################################################
  # is_authorized?
  #
  # Checks if the corresponding role.eql?("owner")
  ##############################################################################

  def self.is_authorized? object
    ret = false

    return ret if basic_check_fails?(object)

    klazz_name = object.class.to_s
    object_reference = object.id

    current_user_id = get_current_user_id

    unless current_user_id.nil?
      or_ = ObjectRole.find( :conditions => { :klazz_name => klazz_name, :object_reference => object_reference, :user_id => current_user_id } )
    end

    # Congratulations, you've been Authorized.
    unless or_.nil?
      ret = true
    end

    ret
  end

  ##############################################################################
  # create_ownership
  #
  # ObjectRole.create!( :klazz_name => object.class.to_s, :object_reference => object.id, :user => current_user, :role => "owner" )
  ##############################################################################

  def self.create_ownership object
    ret = false

    return ret if basic_check_fails?(object)

    klazz_name = object.class.to_s
    object_reference = object.id

    current_user_id = get_current_user_id

    unless current_user_id.nil?
      or_ = ObjectRole.find( :conditions => { :klazz_name => klazz_name, :object_reference => object_reference, :user_id => current_user_id } )
    end

    # This time, we want it to be nil.
    if or_.nil? && !current_user_id.nil?
      ObjectRole.create!( :klazz_name => klazz_name, :object_reference => object_reference, :user_id => current_user_id, :role => "owner" )
    end

    ret
  end

  ##############################################################################
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
  ##############################################################################

  def self.create_brand_new_object_roles(options = {})
    OptionsChecker.check(options, [ :user, :objects ])

    objects = options[:objects]

    current_user_id = get_current_user_id

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

  def self.basic_check_fails?(object)
    !object.is_a?(ActiveRecord::Base) || object.new_record?
  end

  def self.get_current_user_id
    ret = nil

    begin
      ret = current_user.id
    rescue
    end

    ret
  end
end
