class Campaign < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :goal, numericality: {greater_than_or_equal_to: 10}

  geocoded_by :address
  after_validation :geocode

  has_many :pledges, dependent: :destroy

  def pledged_amount
    pledges.sum(:amount)
  end

  def upcased_title
    title.upcase
  end
end
