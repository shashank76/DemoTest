class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    mount_uploader :image, ImageUploader

    has_one :bank_account, dependent: :destroy
    has_many :transactions, dependent: :destroy

    after_create :create_bank_account

    def create_bank_account
	    self.build_bank_account(account_no: rand(100000000000..999999999999), account_type: "saving", account_balance: 0).save
  	end
end
