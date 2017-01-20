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
  end

  def find_email
    p 'find email is clicked'
    @opportunity = Opportunity.find_by_id(params[:id])
    if @opportunity.opening.company.contacts.count != 0
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

  # def seed_company
  #   @companies = []
  #
  #   File.foreach(Dir.pwd + '/app/assets/test.csv') do |line|
  #     line = line.split(',')
  #     @companies.push(
  #       Company.create({
  #         linkedin_id: line[0],
  #         kind: line[1],
  #         name: line[2],
  #         linkedin_url: line[3],
  #         industry: line[4],
  #         city: line[5],
  #         state: line[6],
  #         country: line[7],
  #         size: line[8],
  #         website: line[9],
  #         description: line[10]
  #       })
  #     )
  #   end
  # end

  private

  def company_params
    params.require(:company).permit(:name, :website, :description)
  end


end
