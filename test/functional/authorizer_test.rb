# -*- encoding : utf-8 -*-
require 'test_helper'

# Authorizer
require 'authorizer/base'
require 'authorizer/admin'

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

    assert Authorizer::Admin.create_brand_new_object_roles( :objects => objects, :user => @user )

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
    assert_equal c - 1, ObjectRole.count, "Your Observers probably aren't configured"
  end

  def test_delete_auth_object_when_associated_object_gets_deleted
    # Create some authorization
    Authorizer::Base.authorize_user( :object => @post )
    # Count
    c = ObjectRole.count
    # Now let's delete the user.
    @post.destroy
    # Checks
    assert_equal c - 1, ObjectRole.count, "Your Observers probably aren't configured"
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
    Authorizer::Admin.remove_all_unused_authorization_objects
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
    array = Authorizer::Base.find("Post", :all)
    assert array.is_a?(Array)
    assert_equal 0, array.size

    assert_raise ActiveRecord::RecordNotFound do
      Authorizer::Base.find("Post", :first)
    end
    # Create two posts
    p1 = Factory.create :post
    p2 = Factory.create :post
    # Hello
    Authorizer::Base.authorize_user( :object => p1 )
    Authorizer::Base.authorize_user( :object => p2 )
    # Create a different user
    user2 = Factory.create(:user)
    num_objects_user2 = Authorizer::Base.find("Post", :all, nil, :user => user2)
    assert_equal 0, num_objects_user2.size
    # Now do something
    a = Authorizer::Base.find("Post", :all)
    assert a.is_a?(Array)
    assert_equal 2, a.size
    # Another line
    b = Authorizer::Base.find("Post", :first)
    assert b.is_a?(Post)
    # 1 more line
    c = Authorizer::Base.find("Post", :last)
    assert c.is_a?(Post)
    # another one
    find_options = { :limit => 1 }
    d = Authorizer::Base.find("Post", :all, find_options, { :user => @user })
    assert_equal 1, d.size
    # More
    find_ids = [ p1.id, p2.id, 999, 888, 777 ] # These last 3 shouldn't be a problem at all, since they're not in the list of authorized Posts.
    e = Authorizer::Base.find("Post", find_ids)
    assert_equal 2, e.size
  end
end
