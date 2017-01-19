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
    response = self.class.get(
      params
    )
    data = response.parsed_response["data"]
    @email = data['email']
    @score = data['score']
  end

  def send_email
    p 'send_email called'
    msg = Mail.new
    msg.date = Time.now
    msg.subject = 'This is another email send on 9:17'
    msg.body = 'Hello, world'
    msg.content_type = 'text/html'
    msg.to = 'Sophie Luo <sophie@groobusiness.com>'
    msg.from = 'me'

    ap msg

    client = Google::APIClient.new
      client.authorization.access_token = Token.last.fresh_token
      service = client.discovered_api('gmail')
    result = client.execute(
    api_method: service.users.messages.to_h['gmail.users.messages.send'],
    body_object: {
        raw: Base64.urlsafe_encode64(msg.to_s)
    },
    parameters: {
        userId: 'me',
    },
    headers:   { 'Content-Type' => 'application/json' }
    )
    ap result
    @email = JSON.parse(result.body)
    ap @email
  end

  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end


end
