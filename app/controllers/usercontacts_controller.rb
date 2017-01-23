class UsercontactsController < ApplicationController

    def index
    end

    def show
    end

    def new
      @company = Company.find_by_id(params[:id])
    end

    def create
      if params[:save]
        @company = Company.find_by_id(params[:id])
        @company.contacts.create(contact_params)
        @user = current_user
        @user.contacts << @company.contacts.last
        redirect_to opportunities_path
        p "add new usercontact"
      else
        @contact = Contact.find_by_id(params[:contact_id])
        @contact.usercontacts.create(task_params)
        @user = current_user
        @user.usercontacts << @contact.usercontacts.last

        add_task

        redirect_to '/dashboard'
      end


    end

    def add_task
      p 'creating calendar event!'
      @task = Usercontact.last
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
        summary: @task.summary,
        location: @task.location,
        start: {dateTime: Time.now.strftime("%Y-%m-%dT%T+0000")},
        end: {dateTime: Time.at(Time.now.to_i + 24*60*60).strftime("%Y-%m-%dT%T+0000")},
        description: @task.description,
      }
      response = client.execute(:api_method => service.events.insert,
      :parameters => {'calendarId' => calendarId,
      'sendNotifications' => true},
      :body => JSON.dump(g_event),
      :headers => {'Content-Type' => 'application/json'})

      @new_event= JSON.parse(response.body)
    end

    private

    def contact_params
      params.require(:contact).permit(:first_name, :last_name)
    end

    def task_params
      params.require(:usercontact).permit(:summary, :location, :start, :end, :description)
    end

end
