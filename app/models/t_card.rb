class TCard < ApplicationRecord
  extend Enumerize
  enumerize :status, in: [:open, :closed], default: :open
  belongs_to :board
  belongs_to :owner, :class_name => 'User'
  has_one :tcard_assignee
  has_one :user, :through => :tcard_assignee
  has_many :likes, :as => :likable, dependent: :delete_all

  after_create_commit { CardBroadcastJob.perform_later self }
  after_update_commit { UpdateCardBroadcastJob.perform_later self }

  def assign(user)
    ActiveRecord::Base.transaction do
      # 担当者が割り当てられている場合は、削除してからアサインする
      if self.tcard_assignee
        TcardAssignee.delete(self.tcard_assignee)
      end
      TcardAssignee.create(
        t_card_id: self.id,
        user_id: user.id
      )
    end
  end

  def remove_assign
    ActiveRecord::Base.transaction do
      # 元から担当者が設定されている場合だけ処理する
      unless self.user.blank?
        tcard_assignee = TcardAssignee.find_by(t_card_id: self.id, user_id: self.user.id)
        if tcard_assignee
          TcardAssignee.delete(tcard_assignee)
        end
      end
    end
  end

  class << self
    def update_status(t_card_id)
      @t_card = TCard.find(t_card_id)
      # statusの値をひっくり返す
      @t_card.status = @t_card.status.open? ? TCard.status.closed : TCard.status.open
      @t_card.save
    end
  end
end
