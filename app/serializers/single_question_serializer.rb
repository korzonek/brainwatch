class SingleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :body, :created_at, :updated_at

  has_many :comments
  has_many :attachments

  def short_title
    object.title.truncate(7)
  end
end
