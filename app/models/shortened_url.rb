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

  has_many :visitors, through: :visits, source: :visitor

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
    self.new(long_url: long_url, user_id: user.id, short_url: self.random_code)
  end

end
