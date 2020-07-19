class User < ApplicationRecord
users_index_show_new_edit_update
    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true}
    validates :password, {presence: true}
end
