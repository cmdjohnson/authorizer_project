# -*- encoding : utf-8 -*-
require 'test_helper'

class AuthorizerTest < ActiveRecord::TestCase
  def setup
    # Log in a user, accessible through @user
    setup_user
  end

  def test_get_topmost_class
    assert_equal Post, Authorizer::Base.send(:get_topmost_class, Rant)
  end
  
  def test_find
    @post = Factory.create(:post)
    @rant = Factory.create(:rant) # Rant is a subclass of Post
    
    objects = []
    
    objects.push @post
    objects.push @rant
    
    for obj in objects
      Authorizer::Base.authorize_user :object => obj
    end
    
    # Find all Post objects. The rant should be found as well.
    f = Authorizer::Base.find("Post", :all)
    
    assert_equal 2, f.count
  end
end
