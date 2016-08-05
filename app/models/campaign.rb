class Campaign < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :goal, numericality: {greater_than_or_equal_to: 10}

  geocoded_by :address
  after_validation :geocode

  has_many :pledges, dependent: :destroy

  has_many :rewards, dependent: :destroy
  accepts_nested_attributes_for :rewards, reject_if: :all_blank, allow_destroy: true

  include AASM

  aasm whiny_transitions: false do
    state :draft, initial: true
    state :submitted
    state :declined
    state :approved
    state :canceled
    state :published
    state :succeeded
    state :failed

    event :submit do
      transitions from: :draft, to: :submitted
    end

    event :decline do
      transitions from: :submitted, to: :declined
    end

    event :approve do
      transitions from: :submitted, to: :approved
    end

    event :redo do
      transitions from: :declined, to: :draft
    end

    event :cancel do
      transitions from: [:approved, :published], to: :canceled
    end

    event :succeed do
      transitions from: :published, to: :succeeded
    end

    event :fail do
      transitions from: :published, to: :failed
    end

  end

  def pledged_amount
    pledges.paid.sum(:amount)
  end

  def upcased_title
    title.upcase
  end
end
