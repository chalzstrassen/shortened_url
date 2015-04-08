class TagTopic < ActiveRecord::Base
  validates :topic, presence: true

  has_many :taggings,
    class_name: "Tagging",
    foreign_key: :tag_topic_id,
    primary_key: :id
end
