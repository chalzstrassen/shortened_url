class ShortenedUrl < ActiveRecord::Base
  validates :long_url, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :tag_topics,
    Proc.new { distinct },
    through: :taggings,
    source: :tag_topic

  def self.random_code
    begin
      code = SecureRandom::urlsafe_base64
      raise if ShortenedUrl.exists?(short_url: code)
    rescue
      retry
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    user.submitted_urls.new(long_url: long_url, short_url: self.random_code)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
     self.visits.where("created_at > ?", 60.minutes.ago).select(:user_id).distinct.count

  end
end
