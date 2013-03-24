class Note < ActiveRecord::Base
  acts_as_list

  attr_accessible :content, :format
  belongs_to :user, touch: true
  has_many :items
  has_many :notable_filepickers
  
  validates_presence_of :user_id
  validates_presence_of :content
  validates_presence_of :format
  
end
