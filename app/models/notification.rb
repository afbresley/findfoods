class Notification < ActiveRecord::Base

	include Rails.application.routes.url_helpers

  validates :event_id, inclusion: { in: NOTIFICATION_EVENTS.keys }
  validates :is_read, inclusion: { in: [true, false] }
  validates :notifiable, :user, presence: true

	belongs_to :notifiable, polymorphic: true
  belongs_to :user, inverse_of: :notifications, counter_cache: true

	def url
		case self.event_name
		when :received_review
			fail
		when :received_comment
			
		when :were_tagged
			
		end
	end

	def event_name
		NOTIFICATION_EVENTS[self.event_id]
	end

	def text
		case self.event_name
		when :received_review
			source_comment = Comment.find(notifiable_id)
			reviewer = User.find(source_comment.user_id)
			restaurant = source_comment.commentable
			return "Your restaurant, #{ restaurant.name }, was reviewed by #{ reviewer.fname }."
			
		when :received_comment
			source_comment = Comment.find(notifiable_id)
			reviewer = User.find(source_comment.user_id)
			return "Your review received a comment by #{ reviewer.fname }."

		when :were_tagged
			source_tag = Tag.find(notifiable_id)
			restaurant = source_tag.restaurant
			reviewer = source_tag.author	
			return "Your restaurant, #{ restaurant.name }, was tagged by #{ reviewer.fname }."
			
		end
	end

	def read! 
		self.update(is_read: true)
	end



  def default_url_options
    options = {}
    options[:host] = Rails.env.production? ? "http://afbfindfood.herokuapp.com" : "localhost:3000"
    options
  end

end
