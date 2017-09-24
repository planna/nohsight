class Comment < ApplicationRecord
   belongs_to :user
   belongs_to :event

   validates :user_id,  presence: true
   validates :event_id, presence: true
   validates :content,  presence: true
end
