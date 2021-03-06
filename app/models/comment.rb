class Comment < ActiveRecord::Base

	belongs_to :commentable, polymorphic: true

	validates :body, :user, presence: true

	belongs_to(
		:user,
		class_name: "User",
		foreign_key: :user_id,
		primary_key: :id,
		inverse_of: :written_comments
	)

	has_many(
		:child_comments,
		class_name: "Comment",
		foreign_key: :parent_comment_id,
		primary_key: :id
	)

	belongs_to(
		:parent_comment,
		class_name: "Comment",
		foreign_key: :parent_comment_id,
		primary_key: :id
	)

	has_many :notifications, as: :notifiable, dependent: :destroy

	has_one :rating, dependent: :destroy

	after_save :notify_owner

	def notify_owner
		if self.parent_comment
			self.notifications.create(
				user_id: Comment.find(parent_comment_id).user_id,
				event_id: NOTIFICATION_EVENTS_IDS[:received_comment],
				is_read: false
			)
		else
			self.notifications.create(
				is_read: false,
				user_id: self.commentable.owner.id,
				event_id: NOTIFICATION_EVENTS_IDS[:received_review]
			)
		end
	end

end

