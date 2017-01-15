class CompaniesController < ApplicationController

  before_action :authorize

  def show
    @company = Company.find_by_id(params[:id])
  end

  # def new
  #   @company = Company.new
  # end

  def create
    company = Company.create(company_params)
  end



  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end
end
