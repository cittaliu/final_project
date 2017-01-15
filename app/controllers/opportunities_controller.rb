class OpportunitiesController < ApplicationController

  def index
    @opportunities = Opportunity.all
  end

  def create
    @company = Company.create(company_params)
    @openings = @company.openings
    @user = current_user
    @user.openings << @openings
  end

  def new

  end

  def show
    @opportunity = Opportunity.find_by_id(params[:id])
  end

  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end

end
