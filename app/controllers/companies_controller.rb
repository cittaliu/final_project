class CompaniesController < ApplicationController

  def show
    @company = Company.find_by_id(params[:id])
  end

end
