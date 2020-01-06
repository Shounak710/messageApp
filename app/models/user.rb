class User < ApplicationRecord
  has_and_belongs_to_many :chatrooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  #Validations
   validates_presence_of :name, :password_digest
   validates :name, uniqueness: true
 
   #encrypt password
   has_secure_password
end
