require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new (Sign Up page)' do
    it 'renders the Sign Up page' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create (Sign Up submission)' do
    it "creates a new user when given username and password" do
      post :create, params: {
        user: {
          username: 'Khai',
          password: 'password'
        }
      }
      found_user = User.find_by_credentials(username: 'Khai',
                                            password: 'password')
      expect(found_user).to be_truthy
      expect(response).to redirect_to '/'
    end

    it "re-render #new when given blank username" do
      post :create, params: {
        user: {
          username: '',
          password: 'password'
        }
      }
      expect(User.all).to be_empty
      expect(response).to render_template :new
      expect(flash[:errors]).not_to be_empty
    end

    it "re-render #new when given password length < 6" do
      post :create, params: {
        user: {
          username: 'Khai',
          password: 'pass'
        }
      }
      expect(User.all).to be_empty
      expect(response).to render_template :new
      expect(flash[:errors]).not_to be_empty
    end

    it "logs the user in" do
      post :create, params: {
        user: {
          username: 'Khai',
          password: 'password'
        }
      }
      expect(session[:session_token]).to eq(User.last.session_token)
    end
  end
end
