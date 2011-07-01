# -*- encoding : utf-8 -*-
require 'test_helper'

require 'authorizer/base'

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

    Authorizer::Base.authorize_user( :object => @post )

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

  def test_delete_auth_object_when_user_gets_deleted
    # Create some authorization
    Authorizer::Base.authorize_user( :object => @post )
    # Count
    c = ObjectRole.count
    # Now let's delete the user.
    @user.destroy
    # Checks
    assert_equal c - 1, ObjectRole.count
  end

  def test_delete_auth_object_when_associated_object_gets_deleted
    # Create some authorization
    Authorizer::Base.authorize_user( :object => @post )
    # Count
    c = ObjectRole.count
    # Now let's delete the user.
    @post.destroy
    # Checks
    assert_equal c - 1, ObjectRole.count
  end

  def test_remove_all_unused_authorization_objects
    # Create some stupid authorization objects
    @post.destroy
    # c
    c = ObjectRole.count
    # gogo
    5.times do
      Factory.create :object_role
    end
    # Now clean it
    Authorizer::Base.remove_all_unused_authorization_objects
    # Check it
    assert_equal c, ObjectRole.count
  end

  def test_remove_authorization
    # count
    c = ObjectRole.count
    # Create some
    Authorizer::Base.authorize_user( :object => @post )
    # Now remove it again
    assert Authorizer::Base.remove_authorization( :object => @post )
    # Check it
    assert_equal c, ObjectRole.count
    # Try it again
    assert_false Authorizer::Base.remove_authorization( :object => @post )
    # And again
    assert_false Authorizer::Base.remove_authorization( :object => @post, :user => @user )
  end

  def test_find
    @post.destroy
    # Check
    assert_nil Authorizer::Base.find(:all, "Post")
    assert_nil Authorizer::Base.find(:first, "Post")
    # Create two posts
    p1 = Factory.create :post
    p2 = Factory.create :post
    # Hello
    Authorizer::Base.authorize_user( :object => p1 )
    Authorizer::Base.authorize_user( :object => p2 )
    # Now do something
    a = Authorizer::Base.find(:all, "Post")
    assert a.is_a?(Array)
    assert_equal 2, a.size
    # Another line
    b = Authorizer::Base.find(:first, "Post")
    assert b.is_a?(Post)
  end
end
