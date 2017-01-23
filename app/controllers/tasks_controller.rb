class TasksController < ApplicationController

  def index
  end

  def new
    @task = Task.new
  end

  def create
    @contact = 
    @user = current_user

  end


  @company = Company.find_by_id(params[:id])
  @company.contacts.create(contact_params)
  @user = current_user
  @user.contacts << @company.contacts.last



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

end
