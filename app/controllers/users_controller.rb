require 'rubygems'
require 'httparty'
require "awesome_print"
require 'google/api_client'

class UsersController < ApplicationController

  before_action :authorize, only: [:dashboard]

  include HTTParty
  format :json

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      UserMailer.welcome_email(user).deliver
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      redirect_to '/signup'
    end
  end

  def get_token
    p 'get token clicked'
    @auth = request.env['omniauth.auth']['credentials']
    p @auth
    p Token.last
    Token.create(
     access_token: @auth['token'],
     refresh_token: @auth['refresh_token'],
     expires_at: Time.at(@auth['expires_at']).to_datetime)
     redirect_to '/dashboard'
  end

  def dashboard
    @user = current_user
    @auth = Token.last
    email
    # google_calendar
    read_calendar
  end

  def new_event
    if params[:save]
      new_calendar(new_project)
      p "add task clicked"
    else
      p "you suck"
    end
  end

  def read_calendar
    @cronofy = Cronofy::Client.new(access_token: "xoTQMfDkfJM19CBoBXIMFh4DKvUnDJlR")

    current_year = Time.now.strftime("%Y").to_i
    current_month = Time.now.strftime("%m").to_i
    current_day = Time.now.strftime("%d").to_i
    @events = @cronofy.read_events(from: Date.new(current_year, current_month, current_day), to: Date.new(current_year, current_month, current_day+7))
    @events.each do |item|
      @location = item['location']
      p @location
    end
    require 'json'
  end

  def google_calendar
    p 'I am google calendar'
    # initializing client
    client = Google::APIClient.new
    client.authorization.access_token = Token.last.fresh_token
    service = client.discovered_api('calendar','v3')
    # determining parameter for specific gapi!!
    # client.discovered_apis.each do |gapi|
    #   puts "#{gapi.title} \t #{gapi.id} \t #{gapi.preferred}"
    # end
    calendarId = 'primary'
    g_event = {
      summary: "Do Something",
      location: "Classroom 3",
      start: {dateTime: Time.now.strftime("%Y-%m-%dT%T+0000")},
      end: {dateTime: Time.at(Time.now.to_i + 24*60*60).strftime("%Y-%m-%dT%T+0000")},
      description: "This is important",
    }
    response = client.execute(:api_method => service.events.insert,
    :parameters => {'calendarId' => calendarId,
    'sendNotifications' => true},
    :body => JSON.dump(g_event),
    :headers => {'Content-Type' => 'application/json'})

    @new_event= JSON.parse(response.body)
  end

  def email
    p "I am your email. I am clicked"

      client = Google::APIClient.new
        client.authorization.access_token = Token.last.fresh_token
        service = client.discovered_api('gmail')
        result = client.execute(
          :api_method => service.users.messages.list,
          :parameters => {'userId' => 'me', 'labelIds' => 'INBOX'},
          :headers => {'Content-Type' => 'application/json'})

        def get_details(id)
        client = Google::APIClient.new
        client.authorization.access_token = Token.last.fresh_token
        service = client.discovered_api('gmail')

        result = client.execute(
          :api_method => service.users.messages.get,
          :parameters => {'userId' => 'me', 'id' => id},
          :headers => {'Content-Type' => 'application/json'})
        data = JSON.parse(result.body)

        { subject: get_gmail_attribute(data, 'Subject'),
          from: get_gmail_attribute(data, 'From'),
          body: get_gmail_attribute_body(data, 'body')}
        end

        def get_gmail_attribute_body(gmail_data, attribute)
          body = gmail_data['payload']['parts'][0]['body']['data']
          if body != nil
          decoded_body = Base64.decode64(body)
          end
        end

        def get_gmail_attribute(gmail_data, attribute)
          headers = gmail_data['payload']['headers']
          array = headers.reject { |hash| hash['name'] != attribute }
          array.first['value']
        end

        @messages = JSON.parse(result.body)['messages'] || []
        @show_messages = []
        @messages.each do |msg|
          @show_messages << get_details(msg['id'])
        end
        ap @show_messages
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
