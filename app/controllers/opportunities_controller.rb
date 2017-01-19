require 'rubygems'
require 'httparty'
require 'emailhunter'
require "awesome_print"

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
    @first_name = @opportunity
    @last_name = @opportunity.opening.company.contacts.last.name

    find_email

  end

  def find_email
    p 'find email is clicked'
    @opportunity = Opportunity.find_by_id(params[:id])
    @first_name = @opportunity.opening.company.contacts.last.name
    @last_name = @opportunity.opening.company.contacts.last.name
    @domain = @opportunity.opening.company.website
    params = 'https://api.hunter.io/v2/email-finder?domain='+@domain+'&first_name='+@first_name+'&last_name='+@last_name+'&api_key=0c75c112169e60f02b2a866c22f049492049b278'
    # p params
    response = self.class.get(
      params
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
