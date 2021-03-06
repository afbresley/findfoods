class UsersController < ApplicationController

  layout false

  def new
    @user = User.new
    @users = User.all
    @restaurants = Restaurant.all
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      sign_in(@user)
      redirect_to root_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to root_url
      # render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @users = User.all
    @restaurants = Restaurant.all
  end

  def edit
    @user = User.find(params[:id])
    @users = User.all
    @restaurants = Restaurant.all
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
      redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(:fname, :mname, :lname, :email, :city, :state, :password, :avatar)
    end
end
