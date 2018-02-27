require 'test_helper'

class ImportationTasksControllerTest < ActionController::TestCase
  setup do
    @importation_task = importation_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:importation_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create importation_task" do
    assert_difference('ImportationTask.count') do
      post :create, :importation_task => { :task_code => @importation_task.task_code }
    end

    assert_redirected_to importation_task_path(assigns(:importation_task))
  end

  test "should show importation_task" do
    get :show, :id => @importation_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @importation_task
    assert_response :success
  end

  test "should update importation_task" do
    put :update, :id => @importation_task, :importation_task => { :task_code => @importation_task.task_code }
    assert_redirected_to importation_task_path(assigns(:importation_task))
  end

  test "should destroy importation_task" do
    assert_difference('ImportationTask.count', -1) do
      delete :destroy, :id => @importation_task
    end

    assert_redirected_to importation_tasks_path
  end
end
