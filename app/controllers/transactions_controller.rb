require 'will_paginate/array'
class TransactionsController < ApplicationController
  before_action :require_user

  def index
  	if current_user.role.eql?("user")
  		@transactions = Transaction.where(user_id: current_user.id).order("created_at desc").paginate(:page => params[:page], :per_page => 10)  
  	else
  		if params[:search].present?
  			@transactions =	User.joins(:bank_account).where(bank_accounts: {account_no: params[:search]}).group(:id).map{|x| x.transactions}.flatten
  			@transactions = @transactions.sort_by{|e| [:created_at]}.reverse.paginate(:page => params[:page], :per_page => 10)
  		else
  			@transactions = Transaction.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  		end
  	end
  	@transactions = Transaction.where(id: params[:transaction]).order("created_at desc").paginate(:page => params[:page], :per_page => 10) if params[:transaction].class.eql?(Array)
  	respond_to do |format|
	  format.html
	  format.csv { send_data @transactions.to_csv }
	  format.xls { send_data @transactions.to_csv(col_sep: "\t") }
	end
  end

  def new
  end

  def create
  	@transaction = current_user.transactions.create(transaction_params)
  	if params[:transaction][:transaction_type].eql?("credit")
  		@transaction.update(total_balance: current_user.bank_account.try(:account_balance) + params[:transaction][:transaction_amount].to_f, transaction_reference: rand(100000000..999999999))
  	elsif params[:transaction][:transaction_type].eql?("debit")
  		@transaction.update(total_balance: current_user.bank_account.try(:account_balance) -params[:transaction][:transaction_amount].to_f, transaction_reference: rand(100000000..999999999))
  	end
  	current_user.bank_account.update(account_balance: @transaction.total_balance)
  	UserMailer.transaction_confirmation(current_user, @transaction).deliver_now	
  	redirect_to transactions_path, notice: 'Transaction completed Successfully.'
  end

  def edit
  end

  def update
    
  end

  def show
  end

  private
  def find_transaction
    @transaction = Transaction.find_by(id: params[:id])
    redirect_to transactions_path unless @transaction
  end

  def transaction_params
    params.require(:transaction).permit(:transaction_type,:transaction_amount,:transaction_reference,:total_balance)
  end
end
