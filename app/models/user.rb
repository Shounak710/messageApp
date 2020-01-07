class User < ApplicationRecord
  has_and_belongs_to_many :chatrooms, dependent: :destroy
  has_many :messages, dependent: :destroy

  # TODO: The following lines are strangely indented.
  # Always use 2 spaces for indentation when programming in Ruby

  #Validations
  validates_presence_of :name, :password_digest
  validates :name, uniqueness: true

  #encrypt password
  has_secure_password
end
