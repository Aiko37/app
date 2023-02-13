class UsersController < ApplicationController
  def abc
    @posts = current_user.posts
  end


  def show
    @user = User.find(params[:id]) 
  end

end
