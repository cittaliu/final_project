class CompaniesController < ApplicationController

  before_action :authorize
  autocomplete :company, :name

  def index
    @companies = Company.all
    if params[:search]
     @companies = Company.name_like("%#{params[:search]}%").order('name')
    else
    end
  end

  def show
    @company = Company.find_by_id(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    company = Company.new(company_params)
    if company.save
    redirect_to '/opportunities/new/'
    else
    flash[:error] = 'failed to create new company. Company already in database'
    redirect_to '/companies/new/'
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end
end
