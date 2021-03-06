class SessionsController < ApplicationController

  def login_form
  end

  def login
    auth_hash = request.env['omniauth.auth']
    #
    user = User.find_by(uid: auth_hash[:uid], provider: 'github')
    # username = params[:username]
# require 'pry'; binding.pry
    if user
      session[:user_id] = user.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      # binding.pry
      if user.save
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not log in"
        flash.now[:messages] = user.errors.messages
        render "login_form", status: :bad_request
        return
      end
    end
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end

#  def create
#    auth_hash = request.env['omniauth.auth']
#
#    user = User.find_by(uid: auth_hash[:uid], provider: 'github')
#    # require 'pry'; binding.pry
#    if user
#      # User was found in the database
#      flash[:status] = :success
#      flash[:result_text] = "Logged in as returning user #{user.name}"
#
#
#    else
#      # User doesn't match anything in the DB
#      # Attempt to create a new user
#      user = User.build_from_github(auth_hash)
#
#      if user.save
#        flash[:status] = :success
#        flash[:result_text] = "Logged in as returning user #{user.name}"
#
#      else
#        # Couldn't save the user for some reason. If we
#        # hit this it probably means there's a bug with the
#        # way we've configured GitHub. Our strategy will
#        # be to display error messages to make future
#        # debugging easier.
#        flash[:status] = :error
#        flash[:result_text] = "Could not create new user account: #{user.errors.messages}"
#        redirect_to root_path
#        return
#      end
#    end
#
#    # If we get here, we have a valid user instance
#    session[:user_id] = user.id
#    redirect_to root_path
#  end
#
#  def destroy
#   session[:user_id] = nil
#   flash[:status] = :success
#   flash[:result_text] = "Successfully logged out!"
#
#   redirect_to root_path
# end
