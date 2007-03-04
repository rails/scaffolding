require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'action_controller/test_process'
require 'active_record/fixtures'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :entries do |t|
    t.column :title,      :string
    t.column :body,       :text
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
end

class Entry < ActiveRecord::Base
end

class WeblogController < ActionController::Base
  scaffold :entry
end

class ScaffoldingTest < Test::Unit::TestCase
  def setup
    @controller = WeblogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first = Entry.create :title => "Welcome to the weblog", :body => "Such a lovely day"
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_list
    get :list
    assert_response :success
    assert assigns(:entries)
  end

  def test_should_show_entry
    get :show, :id => @first.id
    assert_response :success
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_entry
    old_count = Entry.count
    post :create, :entry => { }
    assert_equal old_count+1, Entry.count

    assert_redirected_to :action => 'list'
  end

  def test_should_get_edit
    get :edit, :id => @first.id
    assert_response :success
  end

  def test_should_update_entry
    post :update, :id => @first.id
    assert_redirected_to :action => 'show', :id => @first.id
  end

  def test_should_destroy_entry
    old_count = Entry.count
    post :destroy, :id => @first.id
    assert_equal old_count-1, Entry.count

    assert_redirected_to :action => 'list'
  end
end
