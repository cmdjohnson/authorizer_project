# -*- encoding : utf-8 -*-
require 'test_helper'

# class BankTransactionsControllerTest < ActionController::TestCase
class AuthorizerTest < ActionController::TestCase
  def setup
    setup_user # This gives you @user
    #@object_role = Factory.create :object_role
    @post = Factory.create :post
  end

  def test_trolololololol
    c = ObjectRole.count
    
    assert_false Authorizer::Base.is_authorized?(@post)

    Authorizer::Base.create_ownership(@post)

    assert Authorizer::Base.is_authorized?(@post)
    assert_equal c + 1, ObjectRole.count

    o = ObjectRole.first

    assert_equal "Post", o.klazz_name
    assert_equal @post.id, o.object_reference
    assert_equal @user.id, o.user_id
  end

  def test_create_brand_new_object_roles
    oc = ObjectRole.count

    # Create some posts first
    count = 5
    posts = []

    count.times do
      posts.push Factory.create(:post)
    end

    objects = [ "Post" ]

    Authorizer::Base.create_brand_new_object_roles( :objects => objects, :user => @user )

    assert_equal 6, ObjectRole.count # WHY 6?????????????????????????????????????????????????????????
    # I don't understand factory_girl sometimes.

    for object_role in ObjectRole.all
      assert_equal @user.id, object_role.user_id
      assert_equal "Post", object_role.klazz_name
    end
  end
end
