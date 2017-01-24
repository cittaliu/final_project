class UsercontactsController < ApplicationController

    def index
    end

    def show
      @usercontact = Usercontact.find_by_id(params[:id])
    end

    def new
      @company = Company.find_by_id(params[:id])
    end

    def create
      # TODO: add an boolean attribute in the model
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
      p @task.start
      p @task.end
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
        start: {dateTime: (@task.start+"T23:59:59+0000").to_s},
      end: {dateTime: (@task.end+"T23:59:59+0000").to_s},
        description: @task.description,
      }
      response = client.execute(:api_method => service.events.insert,
      :parameters => {'calendarId' => calendarId,
      'sendNotifications' => true},
      :body => JSON.dump(g_event),
      :headers => {'Content-Type' => 'application/json'})

      @new_event= JSON.parse(response.body)
      p @new_event
    end

    private

    def contact_params
      params.require(:contact).permit(:first_name, :last_name)
    end

    def task_params
      params.require(:usercontact).permit(:summary, :location, :start, :end, :description)
    end

end
