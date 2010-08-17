class Style < ActiveRecord::Base
  
  validates_presence_of :vendor_model, :name, :at_model, :cost
  validates_numericality_of :cost
  
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :sizes, :order => 'size'
  belongs_to :vendor
  has_many :prices, :order => "start_date ASC"
  accepts_nested_attributes_for :prices, :allow_destroy => true
  
  has_many :pairs, :order => "size, status"
  
  
  # has_many :items
  
  def price_of_today
    if prices and not prices.empty?
      return prices[prices.length - 1].price
    else
      return 0
    end
  end
  
  def Style.find_all
    Style.all(:order => 'vendor_id, name')
  end
  
  def Style.find_all_for_selection
    Style.all(:order => 'vendor_id, name').map{|x| [x.name, x.id]}
  end
  
end
