class Account < ApplicationRecord
    validates :name, presence: { message: "Name can't be blank" }, uniqueness: { message: "Name exists" }
    validates :gl, presence: { message: "Account GL can't be blank" }, uniqueness: { message: "GL Already assigned" }
    
    has_many :requests, dependent: :destroy
end
