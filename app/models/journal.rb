class Journal < ActiveRecord::Base
  
  belongs_to :user,
             :class_name => "User",
             :foreign_key => "edited_by"
           
  has_many :entries,
           :order => "debit DESC"
  accepts_nested_attributes_for :entries, :allow_destroy => true
  
  validates_presence_of :entry_date, :title
  validates_numericality_of :total_credit, :total_debit
  validates_length_of :title, :maximum => 255
  validate :debit_must_equal_credit
 
protected

  def debit_must_equal_credit
    errors.add(:debit, '借方與貸方必須相等') if total_debit != total_credit  
  end

end
