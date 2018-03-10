class UserMailer < ApplicationMailer

	def signup_confirmation(user)
	    @user = user
	    mail(:to => @user.email, :subject => "Account Confirmation.")
	end

	def transaction_confirmation(user, transaction)
	    @user = user
	    @transaction = transaction
	    mail(:to => @user.email, :subject => "Transaction Success Alert.")
	end
end
