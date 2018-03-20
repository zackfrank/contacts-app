class V2::ContactsController < ApplicationController
  

  def index
    if current_user
      contacts = current_user.contacts 
    
      search = params[:search]
      if search
        if search.to_i.to_s == search
          search = search.to_i
          contacts = contacts.where("id = ?", "#{search}")
           # OR phone_number ILIKE ?", "#{search}", "%#{search}%").order("id")
        else
          contacts = contacts.where("first_name ILIKE ? OR last_name ILIKE ? OR middle_name ILIKE ? OR email ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").order("id")
        end
      end
      render json: contacts.as_json
    else
      render json: {message: "You do not have permission to view this page."}, status: :unauthorized
    end
  end
  
  def show
    contact = Contact.find_by(id: params["id"])
    contact_info = 
    {
      first_name: contact.first_name,
      last_name: contact.last_name,
      middle_name: contact.middle_name || "Not Given",
      full_name: contact.full_name,
      bio: contact.bio,
      email: contact.email,
      phone_number: contact.phone_number
    }
    render json: contact_info.as_json
  end

  def create
    if current_user 
      contact = Contact.new(
        first_name: params["first_name"],
        last_name: params["last_name"],
        middle_name: params["middle_name"],
        bio: params["bio"],
        email: params["email"],
        phone_number: params["phone_number"],
        user_id: current_user.id
      )

      if contact.save
        render json: contact.as_json
      else 
        render json: {errors: contact.errors.full_messages}, status: 422
      end
    else
      render json: {message: "You do not have permission to create a contact. Please login or signup."}, status: :unauthorized
    end
  end

  def update
    contact = Contact.find_by(id: params["id"])

    contact.first_name = params["first_name"] || contact.first_name
    contact.last_name = params["last_name"] || contact.last_name
    contact.middle_name = params["middle_name"] || contact.middle_name
    contact.bio = params["bio"] || contact.bio
    contact.email = params["email"] || contact.email
    contact.phone_number = params["phone_number"] || contact.phone_number

    if contact.save
      render json: contact.as_json
    else 
      render json: {errors: contact.errors.full_messages}, status: 422
    end
  end

  def destroy
    contact = Contact.find_by(id: params["id"])
    contact.delete

    render json: {message: "Contact successfully deleted."}
  end

end
