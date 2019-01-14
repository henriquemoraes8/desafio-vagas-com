module V1
  class JobsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      location = Location.find_by_name(params[:localizacao])
      return render json: {success: false, message: "localização inválida"}, :status => 400 if location.nil?
      @job = Job.new(job_params)
      @job.location = location
      @job.save
      render 'jobs/show', :status => 200
    end

    def index
      @jobs = Job.all
      render 'jobs/index', :status => 200
    end

    private

    def job_params
      params.permit([:empresa, :titulo, :descricao, :nivel, :company, :title, :level, :description])
    end
  end
end
