class ContactsController < ApplicationController

  autocomplete :contact, :first_name

  def index

    # @contacts = User.find_by_id(current_user.id).contacts
    @contacts = []
    @user_contacts = User.find_by_id(current_user.id).contacts
    @all_contacts= Contact.all

    @current_user_contacts_id =[]

    @user_contacts.each do |contact|
       @current_user_contacts_id << contact.id
    end

    @current_user_contacts_id = @current_user_contacts_id.uniq

    @current_user_contacts_id.each do |one_contact|
      push_contact = Contact.find(one_contact)
      @contacts << push_contact
    end

    # p @contacts

    if params[:search]
     @contacts = Contact.first_name_like("%#{params[:search]}%").order('first_name')
    end

    respond_to do |format|
    format.html
    format.json { @contacts = Contact.search(params[:term]) }
    end
  end

  def show
    @contact = Contact.find_by_id(params[:contact_id])
    @task = @contact.usercontacts.new
    # adding new usercontact
    @user = User.find_by_id(params[:id])
  end

  def new
    @company = Company.find_by_id(params[:id])
  end

  def update

  end


  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end

end
