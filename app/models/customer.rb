# == Schema Information
#
# Table name: unico_customers
#
#  city_name  :string(30)       default(""), not null
#  created_at :datetime
#  database   :string(250)
#  disabled   :boolean
#  domain     :string(100)
#  id         :integer          not null, primary key
#  name       :string(30)
#  updated_at :datetime
#

class Customer < UnicoModels

  cattr_accessor :current_database

  self.table_name = "unico_customers"

  scope :active, -> { where( disabled: false ).order(:city_name) }

  serialize :database

  def using_connection(&block)
    ActiveRecord::Base.using_connection(id, database, &block)
  end

end
