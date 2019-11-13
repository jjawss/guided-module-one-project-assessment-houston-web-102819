#ActiveRecord::Base.logger = nil
require_relative '../config/environment'

class MovieApp

  attr_accessor :prompt, :user, :users_movie, :users_option
  
  @prompt = TTY::Prompt.new

########################################################################################
#Methods
########################################################################################

  def self.check_or_create(name)
    prompt = TTY::Prompt.new
    @user = User.find_by({ name: name })
    if @user == nil
      @user = User.create(name: "#{name}")
      return prompt.select("Hello, #{name}, what would you like to do?", ["Select a movie", "User options"])
    else
      return prompt.select("Welcome back #{name}! What would you like to do?", ["Select a movie", "User options"])
    end
  end

  def self.welcome_frame
    puts "Welcome to Movie App!"

    puts "What is your name?"
    current_user = gets.chomp

    @user_choice = check_or_create(current_user)
  end

  def self.movie_titles
    Movie.all.map do |movie|
      movie.title
    end
  end

  def self.movie_menu
    prompt = TTY::Prompt.new
    @users_movie = prompt.select("What movie would you like to see?", movie_titles)
  end
  
  def self.options_menu
    prompt = TTY::Prompt.new
    @users_option = prompt.select("User Options", ["Update name", "Delete user"])
  end

  def self.location_names
    #prompt = TTY::Prompt.new
    @prompt
    Location.all.map do |location|
      location.name
    end
  end
########################################################################################
#USER APP
########################################################################################
  welcome_frame

  if @user_choice == "Select a movie"
    movie_menu
  else 
    options_menu
  end

  #################
  #MOVIE MENU PATH#
  #################
  if @users_movie != nil  #SELECT A TICKET PATH
    location_names

    users_location = @prompt.select("Select a location", location_names)


    movie_object = Movie.where(title: @users_movie)
    location_object = Location.where(name: users_location)
    tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)

    ticket_labels = {}
    tickets_for_movie_location_object.each do |ticket|
      ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}"] = ticket
    end


    users_ticket = @prompt.select("Select a time", ticket_labels)

    puts "You're going to #{users_ticket.location.name} to see #{users_ticket.movie.title} at #{users_ticket.time}."

    users_ticket.user = @user
    users_ticket.save


##############
#Profile Menu#
##############
  elsif @users_option == "Update name"
    puts "What would you like your name to be?"
    updated_name = gets.chomp
    @user.update(name: updated_name)
  
  elsif @users_option == "Delete user" 
    delete_user_choice = @prompt.select("Are you sure you want to Delete your user name?", ["yes", "no"])
    if delete_user_choice == "yes"
      @user.destroy
    else delete_user_choice == "no"
      #return to the beginning of the app
      welcome_frame
    end
  end
end
