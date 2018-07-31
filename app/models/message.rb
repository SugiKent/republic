class Message < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :messageable, polymorphic: true, optional: true
end
