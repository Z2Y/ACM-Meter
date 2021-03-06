class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def login
    identification = login_params[:nickname]
    @user = User.find_by(nickname: identification)
    if @user.blank?
      user_info = UserInfo.find_by("email = ? OR stu_id = ?",
                                    identification, identification)
      @user = user_info.user if user_info.present?
    end
    if @user && @user.authenticate(login_params[:password])
      self.current_user = @user
      render json: current_user, serializer: SessionSerializer
    else
      unauthenticated!
    end
  end

  def register
    @user = User.new
    @user.assign_attributes(register_params)
    if @user.save
      render json: @user
    else
      render json: { error_code: 1 }
    end
  end

  def login_params
    params.permit(:nickname, :password)
  end

  def register_params
    params.permit(:nickname, :password)
  end

  private :login_params, :register_params
end
