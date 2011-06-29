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
    
  end

  ##############################################################################
  # create_ownership
  #
  # ObjectRole.create!( :class_name => object.class.to_s, :object_reference => object.id, :user => current_user, :role => "owner" )
  ##############################################################################

  def self.create_ownership object
    
  end
end
