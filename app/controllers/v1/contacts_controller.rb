class V1::ContactsController < ApplicationController
  
  def first_contact
    contact = Contact.first
    render json: {
      first_name: contact.first_name,
      last_name: contact.last_name,
      email: contact.email,
      phone_number: contact.phone_number
    }
  end

  def all_contacts
    contacts = Contact.all 

    contacts_array = contacts.map do |contact|
      {
      first_name: contact.first_name,
      last_name: contact.last_name,
      email: contact.email,
      phone_number: contact.phone_number
      }
    end

    render json: contacts.as_json
  end
end
