class FacultiesController < ApplicationController
  def index
    @faculties = Faculty.all
    respond_to do |format|
      format.json
    end
  end
end
