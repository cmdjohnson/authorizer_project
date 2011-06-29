# -*- encoding : utf-8 -*-
require 'test_helper'

class ObjectRoleTest < ActiveRecord::TestCase
  def setup
    @object_role = Factory.build :object_role
  end
  
  def test_factory
    assert @object_role.valid?, @object_role.errors.full_messages
  end
end
