require 'rubygems'
require 'httparty'
require 'emailhunter'

class OpportunitiesController < ApplicationController

  include HTTParty
  format :json

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

    find_email

    p @email
  end

  def find_email
    p 'find email is clicked'
    response = self.class.get(
      'https://api.hunter.io/v2/email-finder?domain=groobusiness.com&first_name=Sophie&last_name=Luo&api_key='
    )
    data = response.parsed_response["data"]
    @email = data['email']
    @score = data['score']
  end

  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end

end
