require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  
  test 'create' do
    Post.any_instance.expects(:save).returns(true)
    resource = posts(:basic)
    post :create, :resource => resource.attributes
    assert_response :redirect
  end
  
  test 'create with failure' do
    Post.any_instance.expects(:save).returns(false)
    resource = posts(:basic)
    post :create, :resource => resource.attributes
    assert_template 'new'
  end
  
  test 'update' do
    Post.any_instance.expects(:save).returns(true)
    resource = posts(:basic)
    put :update, :id => posts(:basic).to_param, :resource => resource.attributes
    assert_response :redirect
  end
  
  test 'update with failure' do
    Post.any_instance.expects(:save).returns(false)
    resource = posts(:basic)
    put :update, :id => posts(:basic).to_param, :resource => resource.attributes
    assert_template 'edit'
  end
  
  test 'destroy' do
    Post.any_instance.expects(:destroy).returns(true)
    resource = posts(:basic)
    delete :destroy, :id => resource.to_param
    assert_not_nil flash[:notice] 
    assert_response :redirect
  end
  
  # Not possible: destroy with failure
  
  test 'new' do
    get :new
    assert_response :success
  end
  
  test 'edit' do
    resource = posts(:basic)
    get :edit, :id => resource.to_param
    assert_response :success
  end
  
  test 'show' do
    resource = posts(:basic)
    get :show, :id => resource.to_param
    assert_response :success
  end
  
  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end
  
end