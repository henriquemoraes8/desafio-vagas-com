module V1
  class UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      location = Location.find_by_name(params[:localizacao])
      return render json: {success: false, message: "localização inválida"}, :status => 400 if location.nil?
      @user = User.new(user_params)
      @user.location = location
      @user.save
      render 'users/show', :status => 200
    end

    def index
      @users = User.all
      render 'users/index', :status => 200
    end

    private

    def user_params
      params.permit([:nome, :profissao, :nivel, :name, :job_description, :level])
    end
  end
end
