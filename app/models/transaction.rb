require 'csv'
class Transaction < ApplicationRecord
  belongs_to :user

   def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |transaction|
	      csv << transaction.attributes.values
	    end
	  end
	end

end
