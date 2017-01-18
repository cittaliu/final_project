require 'rubygems'
require 'httparty'
require "awesome_print"

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

  def dashboard
    @user = current_user

    read_calendar
  end

  def get_token
    p 'get token clicked'
    @auth = request.env['omniauth.auth']['credentials']
    p @auth
    Token.create(
     access_token: @auth['token'],
     refresh_token: @auth['refresh_token'],
     expires_at: Time.at(@auth['expires_at']).to_datetime)
     redirect_to '/dashboard'
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # def new_calendar(@new_event)
    #
    #   @cronofy = Cronofy::Client.new(access_token: "xoTQMfDkfJM19CBoBXIMFh4DKvUnDJlR")
    #
    #   @new_event = {
    #     event_id: "unique-event-id",
    #     summary: todo.title,
    #     description: project.description,
    #     start: Time.parse(Time.now.to_s),
    #     end: Time.parse(project.deadline.to_s+" 8:00:00 UTC"),
    #     location: {
    #       description: "GA SF Classroom 3"
    #     }
    #   }
    #
    #   p @new_event
    #
    #   calendar_id = "cal_WHaT@PYZxTP4AAfO_lpXfHiwqNMX0uyzeKct9aQ"
    #   @cronofy.upsert_event(calendar_id, @new_event)
    #
    # end

end
