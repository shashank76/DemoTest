require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  before_action :find_user, except: [:new, :create,:index]

  def index
    @users = User.where(role: "user").order("name asc").paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.signup_confirmation(@user).deliver_now
      @user.update_attributes(sign_in_count: @user.sign_in_count+1)
      session[:user_id] = @user.id
      redirect_to home_index_path, notice: "Your account created successfully."
    else
      redirect_to  new_user_path
      flash[:notice]=  @user.errors.full_messages.first
    end
  end

  def edit

  end

  def update
    @user.role = params[:user][:role] if params[:user][:role].present?
    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: 'User updated Successfully.'
    else
      flash[:notice] = @user.errors.full_messages.first
      render :edit
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      redirect_to  admin_users_path
      @user.alert(request.ip, request.remote_addr, request.env["HTTP_USER_AGENT"], @user.class)
    else
      redirect_to  admin_users_path
    end
  end

  private
  def find_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path unless @user
  end

  def user_params
    params.require(:user).permit(:email,:name,:password,:password_confirmation,:image,:mobile,:address,:status,:state,:dob)
  end
end