class GoalsController < ApplicationController
  before_action :ensure_logged_in
  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash_store(@goal)
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  private

  def goal_params
    params.require(:goal).permit(:body, :goal_type)
  end
end
