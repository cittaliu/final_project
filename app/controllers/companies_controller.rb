class CompaniesController < ApplicationController

  before_action :authorize

  def show
    @company = Company.find_by_id(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    new_company = Company.new(company_params)
    p company_params
    if new_company.save
      redirect_to 'opportunities/new'
    else
      p 'you suck again'
    end
  end



  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end
end
