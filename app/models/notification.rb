class Notification < ActiveRecord::Base

	include Rails.application.routes.url_helpers

	validates :notifiable_id, :notifiable_type, :user_id, :event_id, presence: true
	
	belongs_to :notifiable, polymorphic: true
	belongs_to :user

	def url
	end

	def event_name
		NOTIFICATION_EVENTS[self.event_id]
	end

	def text
		case self.event_name
		when :received_review
			source_comment = Comment.find(notifiable_id)
			reviewer = User.find(source_comment.user_id) #assosiations....
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
end
