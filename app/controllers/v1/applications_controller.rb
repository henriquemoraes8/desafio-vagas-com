module V1
  class ApplicationsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      @application = Application.new(job_id: params[:id_vaga] || params[:job_id], user_id: params[:id_pessoa] || params[:user_id])
      if !@application.save
        render json: {error: @application.errors}, :status => 400
      else
        render 'applications/show', :status => 200
      end
    end

    def ranking
      @applications = Application.for_job(params[:vaga_id])
      render 'applications/index_user'
    end

    def destroy
      Application.destroy(params[:id])
      render json: {success: true}, :status => 200
    end

  end
end
