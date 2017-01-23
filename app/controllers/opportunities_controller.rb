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
    @opportunities = User.find_by_id(current_user.id).opportunities
    @company = Company.find_by_id(params[:id])
  end

  def new
    @current_user_openings =[]
    @company = Company.find_by_id(params[:id])
    @openings = @company.openings
    @opportunities = User.find_by_id(current_user.id).opportunities
    @opportunities.each do |opportunity|
      if opportunity.opening.company_id == @company.id
        @current_user_openings << opportunity
        p "I'm inserted"
      end
    end
    p @current_user_openings
  end

  def create
    @company = Company.find_by_id(params[:id])
    @company.openings.create(opening_params)
    @user = current_user
    @user.openings << @company.openings.last
    redirect_to opportunities_path(current_user)
  end

  def show
    @opportunity = Opportunity.find_by_id(params[:id])

    @current_user_contacts = []
    @company = Company.find_by_id(params[:company_id])
    @companycontacts = @company.contacts

    @companycontacts.each do |companycontact|
      companycontact.usercontacts.each do |usercontact|
        if usercontact.user_id == current_user.id
          @current_user_contacts << usercontact
        end
      end
    end

    @contact = Contact.new

    find_email
  end

  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    redirect_to opportunities_path
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
    # TODO: why cannot add email to opportunity model
    p @opportunity.opening.company.contacts.last.email
    @opportunity.opening.company.contacts.last.email = data['email']
    @opportunity.opening.company.contacts.last.save
    p @opportunity.opening.company.contacts.last.email
    end
  end

  def email_editor
    p 'email editor called'
    @email = Mail.new
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

  def email_params
    params.require(@email).permit(:to, :subject, :body)
  end

end
