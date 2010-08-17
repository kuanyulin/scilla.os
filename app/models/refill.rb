class Refill < ActiveRecord::Base
  
  belongs_to :user,
             :class_name => "User",
             :foreign_key => "made_by"
  
  has_many :pairs, :order => "style_id, size", :autosave => true
  
  accepts_nested_attributes_for :pairs, :allow_destroy => true

  validates_presence_of :order_date, :description
  validates_length_of :description, :maximum => 255 
end
