#ActiveRecord::Base.logger = nil
require_relative '../config/environment'

class MovieApp

  attr_accessor :prompt, :user, :users_movie, :users_option, :users_choice
  
  @prompt = TTY::Prompt.new

########################################################################################
#Methods
########################################################################################

  # def self.check_or_create(name)
  #   prompt = TTY::Prompt.new
  #   @user = User.find_by({ name: name })
  #   if @user == nil
  #     @user = User.create(name: "#{name}")
  #     return prompt.select("Hello, #{name}, what would you like to do?", ["Select a movie", "User options"])
  #   else
  #     return prompt.select("Welcome back #{name}! What would you like to do?", ["Select a movie", "User options"])
  #   end
  # end


  def self.welcome_frame
    puts "Welcome to Movie App!"

    puts "What is your name?"
    current_user = gets.chomp

    check_or_create(current_user)
  end

  def self.check_or_create(name)
    @user = User.find_by({name: name})
    if @user == nil
      @user = User.create(name: "#{name}")
    end
    main_menu
  end

  def self.main_menu
    response = @prompt.select("Hello, #{name}, what would you like to do?", ["Select a movie", "User options"])
    if response == "Select a movie"
      movie_menu
    else
      list_options
    end
  end

  # def self.list_movies
  #   #logic for listing and selecting movies
  #   if response != "back"
  #     #do stuff
  #   else
  #     main_menu
  #   end
  # end


  # def self.main_menu
  #   @users_choice = nil
  #   @users_choice = @prompt.select("Welcome back #{@user.name}! What would you like to do?", ["Select a movie", "User options"])
  # end

  def self.movie_titles
    Movie.all.map do |movie|
      movie.title
    end
  end

  def self.movie_menu
    prompt = TTY::Prompt.new
    #users_movie_menu_selection = nil
    users_movie_menu_selection = prompt.select("What movie would you like to see?", [movie_titles, "back"])
    #movie_object = Movie.where(title: @users_movie)
    @users_movie = users_movie_menu_selection

    if users_movie_menu_selection == "back"
      main_menu
    else
      location_menu
      #users_movie_menu_selection
      #if @users_movie == "back"
        #main_menu
    end
  end

  def self.location_names
    Location.all.map do |location|
      location.name
    end
  end

  def self.location_menu
    #prompt = TTY::Prompt.new
    users_location = @prompt.select("Select a location", location_names)
    movie_times(users_location)
  end
  

  def self.movie_times(users_location)
    movie_object = Movie.where(title: @users_movie)
    location_object = Location.where(name: users_location)
    tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)
    
    ticket_labels = {}
    tickets_for_movie_location_object.each do |ticket|
      ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}"] = ticket
    end
    
    #users_ticket = @prompt.select("Select a time", ticket_labels)
    #print_ticket
    movie_time_menu(ticket_labels)
  end

  def self.movie_time_menu(labels)
    users_ticket = @prompt.select("Select a time", labels)
    print_ticket(users_ticket)
  end

  def self.print_ticket(users_ticket)
    puts "You're going to #{users_ticket.location.name} to see #{users_ticket.movie.title} at #{users_ticket.time}."
  end
  
  def self.options_menu
    prompt = TTY::Prompt.new
    @users_option = prompt.select("User Options", ["Update name", "Delete user"])
  end
  welcome_frame
end
########################################################################################
#USER APP
########################################################################################

#   if @users_choice == "Select a movie"
#     movie_menu
#   else 
#     options_menu
#   end
# end
  #################
  #MOVIE MENU PATH#
  #################
  # if @users_movie != nil  #SELECT A TICKET PATH
  #   location_names

  #   users_location = @prompt.select("Select a location", location_names)


  #   movie_object = Movie.where(title: @users_movie)
  #   location_object = Location.where(name: users_location)
  #   tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)

  #   ticket_labels = {}
  #   tickets_for_movie_location_object.each do |ticket|
  #     ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}"] = ticket
  #   end


  #   users_ticket = @prompt.select("Select a time", ticket_labels)

  #   puts "You're going to #{users_ticket.location.name} to see #{users_ticket.movie.title} at #{users_ticket.time}."

  #   users_ticket.user = @user
  #   users_ticket.save


##############
#Profile Menu#
##############
#   elsif @users_option == "Update name"
#     puts "What would you like your name to be?"
#     updated_name = gets.chomp
#     @user.update(name: updated_name)
  
#   elsif @users_option == "Delete user" 
#     delete_user_choice = @prompt.select("Are you sure you want to Delete your user name?", ["yes", "no"])
#     if delete_user_choice == "yes"
#       @user.destroy
#     else delete_user_choice == "no"
#       #return to the beginning of the app
#       welcome_frame
#     end
#   end
# end



# class View

#   def check_or_create(name)
#      @@user = User.find_by({ name: name })
#     if @@user == nil
#       @@user = User.create(name: "#{name}")
#     end
#   end

#   @@all = []
#   @@prompt = TTY::Prompt.new

#   def initialize(view = 'login')
#     @view = view
#     @@all.push(self)
#   end

#   def run 
#     if(@view == 'login')
#       puts "Welcome to Movie App!"
#       puts "What is your name?"
#       current_user = gets.chomp
#       check_or_create(current_user)
#       View.open('main menu')
#     elsif(@view == 'main menu')
#       selection = @@prompt.select("Hello, #{@@user.name}, what would you like to do?", ["Select a movie", "User options", "Back"])
#       View.open(selection)
#     elsif(@view == 'Select a movie')

#     elsif(@view == 'User options')

#     elsif(@view == 'Back')
#       @@all.pop() # Get rid of back
#       @@all.pop() # Get rid of the most recent view
#       previous_view = @@all.last 
#       previous_view.run
#     end
#   end


#   def self.open(view = 'login')
#     view = View.new(view)
#     view.run
#   end

# end

# View.open()
