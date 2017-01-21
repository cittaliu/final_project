class CompaniesController < ApplicationController

  before_action :authorize
  autocomplete :company, :name

  def index
    @companies = Company.all
    if params[:search]
     @companies = Company.name_like("%#{params[:search]}%").order('name')
    else
    end
    # seed_company
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

  def seed_company
    Company.destroy_all

    @companies = []

    File.foreach(Dir.pwd + '/app/assets/test.csv') do |line|
      line = line.split(',')
      @companies.push(
        Company.create({
          linkedin_id: line[0],
          kind: line[1],
          name: line[2],
          linkedin_url: line[3],
          industry: line[4],
          city: line[5],
          state: line[6],
          country: line[7],
          size: line[8],
          website: line[9],
          description: line[10]
        })
      )
    end
  end

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end
end
