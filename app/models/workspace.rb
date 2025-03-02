class Workspace < ApplicationRecord
  has_many :incidents, dependent: :destroy

  validates :team_id, presence: true, uniqueness: true
  validates :access_token, presence: true
end
