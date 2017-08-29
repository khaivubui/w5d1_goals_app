require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:jon) { User.create(username: 'JonSnow', password: 'password') }

  describe 'GET #index' do
    context 'when logged in' do
      it 'renders :index' do
        allow(controller).to receive(:current_user) { jon }
        get :index
        expect(response).to render_template :index
        expect(response).to have_http_status 200
      end
    end

    context 'when not logged in' do
      it 'redirects to new_session_url' do
        get :index
        expect(response).to redirect_to new_session_url
      end
    end
  end

  describe 'GET #show' do
    let(:bang_dany) do
      Goal.create(body: 'Bang Dany',
      goal_type: 'PRIVATE',
      user_id: jon.id)
    end

    context 'when logged in' do
      it 'renders :show' do
        allow(controller).to receive(:current_user) { jon }
        get :show, params: { id: bang_dany.id }
        expect(response).to render_template :show
        expect(response).to have_http_status 200
      end
    end

    context 'when not logged in' do
      it 'redirects to new_session_url' do
        get :show, params: { id: bang_dany.id }
        expect(response).to redirect_to new_session_url
      end
    end
  end

  describe 'GET #new' do
    context 'when logged in' do
      it 'renders :new' do
        allow(controller).to receive(:current_user) { jon }
        get :new
        expect(response).to render_template :new
        expect(response).to have_http_status 200
      end
    end

    context 'when not logged in' do
      it 'redirects to new_session_url' do
        get :new
        expect(response).to redirect_to new_session_url
      end
    end
  end

  describe 'POST #create' do
    context 'when logged in' do

      it 'creates a new post when given valid params' do
        allow(controller).to receive(:current_user) { jon }
        post :create, params: {
          goal: {
            body: 'Bang Dany',
            goal_type: 'PRIVATE'
          }
        }
        goal = Goal.last
        expect(goal.body).to eq('Bang Dany')
        expect(goal.goal_type).to eq('PRIVATE')
        expect(goal.user).to eq(User.find_by(username: 'JonSnow'))
        expect(response).to redirect_to goal_url(Goal.last)
      end

      it 're-render with errors when given empty body' do
        allow(controller).to receive(:current_user) { jon }
        post :create, params: {
          goal: {
            body: '',
            goal_type: 'PRIVATE'
          }
        }
        expect(Goal.all).to be_empty
        expect(response).to render_template :new
        expect(flash[:errors]).not_to be_empty
      end

      it 're-render with errors when given incorrect goal type' do
        allow(controller).to receive(:current_user) { jon }
        post :create, params: {
          goal: {
            body: '',
            goal_type: 'PROTECTED'
          }
        }
        expect(Goal.all).to be_empty
        expect(response).to render_template :new
        expect(flash[:errors]).not_to be_empty
      end
    end

    context 'when not logged in' do
      it 'redirects to new_session_url' do
        post :create, params: {
          goal: {
            body: 'Bang Dany',
            goal_type: 'PRIVATE'
          }
        }
        expect(response).to redirect_to new_session_url
      end
    end
  end

  describe 'GET #edit' do
    let!(:bang_dany) do
      Goal.create(body: 'Bang Dany',
      goal_type: 'PRIVATE',
      user_id: jon.id)
    end

    context 'when logged in' do
      before :each do
        allow(controller).to receive(:current_user) { jon }
      end

      it 'render edit template' do
        get :edit, params: { id: bang_dany.id }
        expect(response).to render_template :edit
      end
    end

    context 'when not logged in' do
      it 'redirects to new_session_url' do
        get :edit, params: { id: bang_dany.id }
        expect(response).to redirect_to new_session_url
      end
    end
  end

  describe 'PATCH #update' do
    let(:bang_dany) do
      Goal.create(body: 'Bang Dany',
                  goal_type: 'PRIVATE',
                  user_id: jon.id)
    end

    before :each do
      allow(controller).to receive(:current_user) { jon }
    end

    it 'updates the goal when given appropriate params' do
      id = bang_dany.id
      patch :update, params: {
        id: id,
        goal: {
          completed: true
        }
      }
      expect(Goal.find(id).completed).to be true
      expect(response).to redirect_to goal_url(bang_dany)
    end

    it 'render errors and does not update when given bad params' do
      patch :update, params: {
        id: bang_dany.id,
        goal: {
          body: ''
        }
      }
      expect(bang_dany.body).to eq 'Bang Dany'
      expect(response).to render_template :edit
      expect(flash[:errors]).not_to be_empty
    end
  end

  describe 'DELETE #destroy' do
    let(:marry_dany) do
      Goal.create(body: 'Marry Dany',
                  goal_type: 'PRIVATE',
                  user_id: jon.id)
    end

    before :each do
      allow(controller).to receive(:current_user) { jon }
    end

    it 'deletes the goal from the database' do
      id = marry_dany.id
      delete :destroy, params: { id: id }
      expect(Goal.exists?(id)).to be false
      expect(response).to redirect_to goals_url
    end
  end
end
