class Contact < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true 
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  belongs_to :user

  def friendly_updated_at
    updated_at.strftime("%A, %B %e %l:%m%p")
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def japanese_phone_number
    "+81 #{phone_number}"
  end

  def as_json
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      middle_name: middle_name,
      full_name: full_name,
      email: email,
      phone_number: japanese_phone_number,
      created_at: created_at,
      updated_at: friendly_updated_at,
      user_id: user_id
    }
  end

end
