class V2::ContactsController < ApplicationController
  

  def index
    contacts = Contact.all 
    contacts_array = contacts.map do |contact|
      {
      first_name: contact.first_name,
      last_name: contact.last_name,
      middle_name: contact.middle_name || "Not Given",
      full_name: contact.full_name,
      bio: contact.bio,
      email: contact.email,
      phone_number: contact.phone_number
      }
    end
    render json: contacts_array.as_json
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
    contact = Contact.create(
      first_name: params["first_name"],
      last_name: params["last_name"],
      middle_name: params["middle_name"],
      bio: params["bio"],
      email: params["email"],
      phone_number: params["phone_number"]
    )

    render json: contact.as_json
  end

  def update
    contact = Contact.find_by(id: params["id"])

    contact.first_name = params["first_name"] || contact.first_name
    contact.last_name = params["last_name"] || contact.last_name
    contact.middle_name = params["middle_name"] || contact.middle_name
    contact.bio = params["bio"] || contact.bio
    contact.email = params["email"] || contact.email
    contact.phone_number = params["phone_number"] || contact.phone_number

    contact.save

    render json: contact.as_json
  end

  def destroy
    contact = Contact.find_by(id: params["id"])
    contact.delete

    render json: {message: "Contact successfully deleted."}
  end

end
