# -*- encoding : utf-8 -*-
require 'test_helper'

class AuthorizerTest < ActiveRecord::TestCase
  def setup
    setup_user
    @object_role = Factory.create :object_role
  end

  def test_create_ownership
    
  end
end
