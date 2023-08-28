class Department < ApplicationRecord
    validates :name, presence: { message: "Name can't be blank" }, uniqueness: { message: "Department exists" }
    has_many :users, dependent: :destroy
end

