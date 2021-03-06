class Api::V1::UsersController < ApplicationController

  def index
    @users = User.with_search(params).with_sort(params)
    @users = @users.page(params[:page] || 1).per(params[:per])
    render json: @users, root: 'items', meta: meta_with_page(@users)
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new
    @user.assign_attributes(user_params)
    @user.update_user_info(params)
    if @user.save!
      render json: @user
    else
      render json: { error_code: 1 }
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update_user_info(params)
    if @user.update!(user_params)
      render json: @user
    else
      render json: { error_code: 1 }
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { error_code: 0 }
    else
      render json: { error_code: 1 }
    end
  end

  def user_params
    params.permit(:name, :nickname, :gender, :avatar, :role, :status, :description)
  end

  private :user_params
end
