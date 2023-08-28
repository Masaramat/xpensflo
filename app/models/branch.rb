class Branch < ApplicationRecord
    validates :name, presence: { message: "Name can't be blank" }, uniqueness: { message: "Branch exists" }
    validates :location, presence: { message: "Location can't be blank" }, uniqueness: { message: "A branch exists in this location" }
    has_many :users, dependent: :destroy
end
