require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new (Sign In page)' do
    it 'renders the Sign In page' do
      get :new
      expect(response).to render_template :new
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #create (Sign In submission)' do
    let! :user do
      User.create(username: 'Apple', password: 'password')
    end

    it 'signs the user in if given correct username and password' do
      post :create, params: {
        user: {
          username: 'Apple',
          password: 'password'
        }
      }
      expect(response).to redirect_to '/'
      expect(session[:session_token]).to be_truthy
    end

    it 're-render the Sign In page given incorrect username' do
      post :create, params: {
        user: {
          username: 'Banana',
          password: 'password'
        }
      }
      expect(response).to render_template :new
      expect(session[:session_token]).to be_falsy
      expect(flash[:errors]).not_to be_empty
    end

    it 're-render the Sign In page given incorrect password' do
      post :create, params: {
        user: {
          username: 'Apple',
          password: '1234567'
        }
      }
      expect(response).to render_template :new
      expect(session[:session_token]).to be_falsy
      expect(flash[:errors]).not_to be_empty
    end
  end
end
