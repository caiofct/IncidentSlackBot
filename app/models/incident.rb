class Incident < ApplicationRecord
  enum :severity, sev0: 0, sev1: 1, sev2: 2
  enum :status, open: 0, resolved: 1

  validates :title, presence: true
  validates :severity, presence: true
  validates :status, presence: true
  validates :created_by, presence: true
  validates :slack_channel_id, presence: true, uniqueness: { scope: :status }
end
