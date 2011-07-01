require 'test_helper'

# for user_not_authorized
require 'authorizer/exceptions'

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
    # Attempt to access the object. Should fail.
    assert_raise Authorizer::UserNotAuthorized do
      get :show, :id => @post
    end
    # Now log in. Should work
    UserSession.create(@user)
    # Gogo
    get :show, :id => @post
    # Now delete the authorization.
    Authorizer::Base.remove_authorization( :object => @post )
    # Try again. Should fail.
    assert_raise Authorizer::UserNotAuthorized do
      get :show, :id => @post
    end
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