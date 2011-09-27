require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @post = Factory.create :post
    # Log in.
    setup_user
    # Create authorization for the user.
    Authorizer::Base.authorize_user( :object => @post )
  end
  
  # Nifty tests to test Authorizer
  
  def test_authorization
    # Let's remove authorization.
    UserSession.find.destroy
    # Now log in. Should work
    UserSession.create(@user)
    # Gogo
    get :show, :id => @post
    # Now delete the authorization.
    Authorizer::Base.remove_authorization( :object => @post )
    # Try again. Should fail.
    #    assert_raise Authorizer::UserNotAuthorized do
    #      get :show, :id => @post
    #    end
    # The exception should be caught by ApplicationController and return status
    # 403 forbidden instead.
    get :show, :id => @post
    assert_response 403
  end

  def test_create_and_own
    post :create, :post => @post.attributes

    assert_equal 2, ObjectRole.count
    o = ObjectRole.last
    p = Post.last

    assert_equal p.id, o.object.id
  end

  # Standard controller tests
  
  test 'create' do
    post :create, :post => @post.attributes
    assert_response :redirect
  end
  
  test 'create with failure' do
    post :create, :post => @post.attributes
    #assert_template 'new'
  end
  
  test 'update' do
    put :update, :id => @post.id, :post => @post.attributes
    assert_response :redirect
  end
  
  test 'update with failure' do
    put :update, :id => @post.id, :post => {}
    #assert_template 'edit'
  end
  
  test 'destroy' do
    delete :destroy, :id => @post.id
    #assert_not_nil flash[:notice]
    assert_response :redirect
  end
  
  # Not possible: destroy with failure
  
  test 'new' do
    get :new
    assert_response :success
  end
  
  test 'edit' do
    get :edit, :id => @post.id
    assert_response :success
  end
  
  test 'show' do
    get :show, :id => @post.id
    assert_response :success
  end
  
  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end
  
end