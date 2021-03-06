class TagsController < ApplicationController

  def new
    @tag = Tag.new
    render :new
  end

  def create
    restaurant = Restaurant.find(params[:tag][:restaurant_id])
    unless params[:tag][:body] == "" || !current_user
      user = User.find(params[:tag][:author_id])
      @tag = user.tags.new(tag_params)
      @tag.restaurant_id = restaurant.id

      @tag.save!
      redirect_to restaurant 
      return 
    end

    redirect_to restaurant
  end

  def destroy
    @tag = Tag.find(params[:id])
    restaurant = Restaurant.find(@tag.restaurant_id)
    @tag.destroy
    redirect_to restaurant 
  end

  def show
  end

  private

    def tag_params
      params.require(:tag).permit(:body)
    end
end
