module V1
  class LocationsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      @location = Location.create(location_params)
      if !@location.save
        render json: {error: @location.errors}, :status => 400
      else
        render 'locations/show', :status => 200
      end
    end

    def index
      @locations = Location.all
      render 'locations/index', :status => 200
    end

    def destroy
      Location.destroy(params[:id])
      render json: {success: true}, :status => 200
    end

    private

    def location_params
      params.permit([:nome, :name])
    end
  end
end
