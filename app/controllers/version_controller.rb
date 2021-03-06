class VersionController < ApplicationController

  #skip_before_filter :require_auth

  # the response
  class VersionResponse

    attr_accessor :build

    def initialize( build )
      @build = build
    end
  end

  # # GET /version
  # # GET /version.json
  def index
    response = VersionResponse.new( BUILD_VERSION )
    render json: response, :status => 200
  end

end
