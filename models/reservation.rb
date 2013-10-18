# encoding: UTF-8

class Reservation
  include Mongoid::Document

  field :phone_number, type: String
  field :email, type: String
  field :date, type: DateTime, default: -> { DateTime.now }
  field :status, type: Symbol, default: :active

  attr_accessible :email, :phone_number

  before_create :escape_fields
  validates_presence_of :phone_number, :email
  validates :status, inclusion: { in: [:active, :inactive] }

  belongs_to :bill

  scope :active_for, ->(bill) { where(bill_id: bill.id, status: :active) }

  def self.active_until_now_for(bill)
    active_until_now(bill).count > 0
  end

  private
  scope :active_until_now, ->(bill) { where(bill_id: bill.id, status: :active, :date.lte => DateTime.now - 1) }

  def escape_fields
    self.phone_number = h self.phone_number
    self.email = h self.email
  end
end
