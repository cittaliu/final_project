require 'rubygems'
require 'httparty'

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

    # if params[:save]
    #   new_calendar(@new_event)
    #   p "i'm posting to your calendar"
    # else
    #   p "you suck"
    # end

  end

  def read_calendar

    @cronofy = Cronofy::Client.new(access_token: "xoTQMfDkfJM19CBoBXIMFh4DKvUnDJlR")
    current_year = Time.now.strftime("%Y").to_i
    current_month = Time.now.strftime("%m").to_i
    @events = @cronofy.read_events(from: Date.new(current_year, current_month, 1), to: Date.new(current_year, current_month+1, 1))

    require 'json'

    @events.each do |item|
      @summary = item['summary']
      @start = item['start']
      @end_date = item['end']
      p @summary
      p @start
      p @end_date
    end

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
