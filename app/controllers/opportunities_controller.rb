require 'rubygems'
require 'httparty'
require 'emailhunter'
require "awesome_print"
require "mail"
require 'json'

class OpportunitiesController < ApplicationController

  include HTTParty
  format :json

  def index
    @opportunities = Opportunity.all
    @company = Company.find_by_id(params[:id])
  end

  def new
    @company = Company.find_by_id(params[:id])
    @openings = @company.openings
  end

  def create
    @company = Company.find_by_id(params[:id])
    @company.openings.create(opening_params)
    @user = current_user
    @user.openings << @company.openings.last
    redirect_to '/opportunities'
  end

  def show
    @opportunity = Opportunity.find_by_id(params[:id])
    @contacts = @opportunity.opening.company.contacts
    find_email
  end

  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    redirect_to('/opportunities')
  end

  def find_email
    p 'find email is clicked'
    @opportunity = Opportunity.find_by_id(params[:id])
    if @opportunity.opening.company.contacts.count != 0
    @first_name = @opportunity.opening.company.contacts.last.first_name
    @last_name = @opportunity.opening.company.contacts.last.last_name
    @domain = @opportunity.opening.company.website
    params = 'https://api.hunter.io/v2/email-finder?domain='+@domain+'&first_name='+@first_name+'&last_name='+@last_name+'&api_key=0c75c112169e60f02b2a866c22f049492049b278'
    response = self.class.get(
      params
    )
    data = response.parsed_response["data"]
    @email = data['email']
    @score = data['score']
    p @opportunity.opening.company.contacts.last.email
    @opportunity.opening.company.contacts.last.email = data['email']
    @opportunity.opening.company.contacts.last.save
    p @opportunity.opening.company.contacts.last.email
    end
  end

  def send_email
    p 'send_email called'
    msg = Mail.new
    msg.date = Time.now
    msg.subject = 'I am sending you another email'
    msg.body = 'Hello, world. I can send emails now!!'
    msg.content_type = 'text/html'
    msg.to = 'sophie@groobusiness.com'
    msg.from = 'me'

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

  def opening_params
    params.require(:opening).permit(:name, :company_id)
  end

end
