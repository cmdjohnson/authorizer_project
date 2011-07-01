require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @post = Factory.create :post
  end
  
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