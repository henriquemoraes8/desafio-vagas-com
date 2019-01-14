module V1
  class ApplicationsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      @application = Application.create(job_id: params[:id_vaga] || params[:job_id], user_id: params[:id_pessoa] || params[:user_id])
      render 'applications/show', :status => 200
    end

    def ranking
      @applications = Application.for_job(params[:vaga_id])
      render 'applications/index_user'
    end

    def destroy
      Application.destroy(params[:application_id])
      render json {}, :status => 200
    end

  end
end
