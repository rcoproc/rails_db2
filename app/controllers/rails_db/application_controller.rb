module RailsDb
  class ApplicationController < ActionController::Base
    helper :all
    helper_method :per_page

    around_filter :handle_customer, if: :handle_customer?

    if Rails::VERSION::MAJOR >= 4
      before_action :verify_access
    else
      before_filter :verify_access
    end

    if RailsDb.http_basic_authentication_enabled
      http_basic_authenticate_with name: RailsDb.http_basic_authentication_user_name,
                                   password: RailsDb.http_basic_authentication_password
    end

    def handle_customer(&block)
      if @customer_id.present?
        # puts "*** pesquisando o cliente: (#{@customer_id})" 
        @customer ||= Customer.find(@customer_id) # Conex√£o remota de Clientes
        if @customer
          @customer.using_connection(&block)          # Todas actions do block ser√£o feitos na conex√£o(pg) encontrada
        else
          domain_not_found
        end
      else
        puts "*** Em RAILS_DB Trabalhando com localhost"
        yield
      end
    end

    def handle_customer?
      if !@customer_id.present?
        @customer_id = session[:customer_id].to_i || 0
      end
      @customer_id > 0
    end

    private

    def verify_access
      result = RailsDb.verify_access_proc.call(self)
      redirect_to('/', error: 'Access Denied', status: 401) unless result
    end

    def per_page
      params[:per_page] || session[:per_page]
    end

  end
end

