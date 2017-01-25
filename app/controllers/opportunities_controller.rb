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
    # TODO: same issue, why cannot assign value?
    @user.opportunities.last.status = "Created"
    redirect_to opportunities_path(current_user)
  end

  def edit
  end

  def updated
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

    @email_clicked = 0
    p "printing"
    p @email_clicked
    p "printing again"

    find_email
  end

  def destroy
    @opportunity = Opportunity.find(params[:id])
    @opportunity.destroy

    redirect_to opportunities_path
  end

  def find_email
    p 'find email is clicked'
    @email_clicked = 1

    @opportunity = Opportunity.find_by_id(params[:id])

    if @opportunity.opening.company.contacts.count != 0
    @first_name = @opportunity.opening.company.contacts.last.first_name
    @last_name = @opportunity.opening.company.contacts.last.last_name
    @domain = @opportunity.opening.company.website
    p @first_name
    p @last_name
    p @domain

    params = 'https://api.hunter.io/v2/email-finder?domain='+@domain+'&first_name='+@first_name+'&last_name='+@last_name+'&api_key=0c75c112169e60f02b2a866c22f049492049b278'
    response = self.class.get(
      params
    )
    data = response.parsed_response["data"]
    @email = data['email']
    @score = data['score']

    # update_contact

    end
  end

  def update_contact
    p "update contact called"
    @contact = @opportunity.opening.company.contacts.last
    p @contact
    @contact.update({:email => @email})
    p @contact
  end

  def email_editor

    @opportunity = Opportunity.find_by_id(params[:id])
    @contact = @opportunity.opening.company.contacts.last

    # for setting email params

    # @email_string = Mail.new.to_s

    if params[:inject]
      p "inject called"
      # msg = Mail.new
      # msg.date = Time.now
      # msg.subject = 'I am sending you another email'
      # msg.body = 'Hello, world. I can send emails now!!'
      # msg.content_type = 'text/html'
      # msg.to = 'sophie@groobusiness.com'
      # msg.from = 'me'
      @key = params.keys[2]

      @subject = params[@key][:subject]

      @email_string = @key[0..38]+"From: me\r\nTo: sophie@groobusiness.com\r\n"+@key[39..122]+"Subject: "+@subject+"\r\n"+@key[123..205]+@subject
      send_email
      # @new_email = params
      # p @new_email
      # p @email_string
    else
      p "you suck"
    end

      # def inject
      #   p "inject called"
      #   p @new_email
      #   @new_email << @email_string
      #   p @new_email
      # end

  end

  def send_email
    # p 'send_email called'
    # msg = Mail.new
    # msg.date = Time.now
    # msg.subject = 'I am sending you another email'
    # msg.body = 'Hello, world. I can send emails now!!'
    # msg.content_type = 'text/html'
    # msg.to = 'sophie@groobusiness.com'
    # msg.from = 'me'
    p "send email called"

    # @new_email.date = Time.now
    # @new_email.body = "hello this is a new email"
    # @new_email.content_type = 'text/html'
    # @new_email.to = 'sophie@groobusiness.com'
    # @new_email.from = 'me'

    client = Google::APIClient.new
      client.authorization.access_token = Token.last.fresh_token
      service = client.discovered_api('gmail')
    result = client.execute(
    api_method: service.users.messages.to_h['gmail.users.messages.send'],
    body_object: {
        raw: Base64.urlsafe_encode64(@email_string)
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
    params.permit(:to, :subject, :body)
  end

end
