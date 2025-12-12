class ClientsController < ApplicationController
  def index
    puts "\n\n\n ================================================== \n\n\n"
    puts current_user.role
  end
end
