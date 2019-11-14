
require_relative '../config/environment'


class MovieApp
    ActiveRecord::Base.logger = nil

    attr_accessor :prompt, :user, :users_movie, :users_option, :users_choice, :a

    @a = Artii::Base.new :font => 'slant'
    @prompt = TTY::Prompt.new
    String.disable_colorization = false


  def self.welcome_frame
    puts @a.asciify(" Welcome").red
    puts @a.asciify("         to")
    puts @a.asciify("Movie App!").red

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
    response = @prompt.select("Hello #{@user.name}, what would you like to do?", ["Select a movie", "View my profile"])
    if response == "Select a movie"
      movie_menu
    else
      profile_menu
    end
  end


  def self.movie_titles
    Movie.all.map do |movie|
      movie.title
    end
  end

  def self.movie_menu
    prompt = TTY::Prompt.new
    users_movie_menu_selection = prompt.select("What movie would you like to see?", [movie_titles, "Back".red])
    @users_movie = users_movie_menu_selection

    if users_movie_menu_selection == "Back"
      main_menu
    else
      location_menu
    end
  end

  def self.location_names
    Location.all.map do |location|
      location.name
      end
  end


  def self.location_menu
    #prompt = TTY::Prompt.new
    users_location = @prompt.select("Select a location", [location_names, "Back".red])
    if users_location == "Back"
      movie_menu
    else
       movie_times(users_location)
    end
  end
  

  def self.movie_times(users_location)
    movie_object = Movie.where(title: @users_movie)
    location_object = Location.where(name: users_location)
    tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)
    
    ticket_labels = {}
    tickets_for_movie_location_object.each do |ticket|
      ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}0"] = ticket
    end
    movie_time_menu(ticket_labels)
  end

  def self.movie_time_menu(labels)
    labels["Back".red] = "Back"
    users_ticket = @prompt.select("Select a time", labels)
    if users_ticket == "Back"
      location_menu
    else
      users_ticket.user = @user
      users_ticket.save
      print_ticket(users_ticket)
    end
  end

  def self.print_ticket(users_ticket)
    puts "You're going to #{users_ticket.location.name} to see #{users_ticket.movie.title} at #{users_ticket.time}.".yellow

    response = @prompt.select("What would you like to do next?", ["Main menu", "Exit"])
    
    if response == "Main menu"
        main_menu
    else response == "Exit"
        exit
    end

  end

   #PROFILE BRANCH------------------------------
  def self.profile_menu
    profile_menu_choice = @prompt.select("Welcome to your profile.", ["Update profile name", "Delete profile", "Favorite genre", "Favorite theater", "My movie list", "Back".red])

    if profile_menu_choice == "Update profile name"
        update_user
    elsif profile_menu_choice == "Delete profile"
        delete_user
    elsif profile_menu_choice == "Favorite genre"
        favorite_genre
    elsif profile_menu_choice == "Favorite theater"
        most_visited_theater
    elsif profile_menu_choice == "My movie list"
        movies_history
    elsif profile_menu_choice == "Back"
        main_menu
    end
  end

  def self.update_user
    puts "What would you like your name to be?"
    updated_name = gets.chomp
    @user.update(name: updated_name)
    puts "Your user name has been updated to #{updated_name}."
    
    profile_menu
  end

  def self.delete_user
    delete_user_choice = @prompt.select("Are you sure you want to delete your user name?", ["Yes", "No"])
    if delete_user_choice == "Yes"
      @user.destroy
    else delete_user_choice == "No"
      profile_menu
    end
  end

  def self.favorite_genre
    tickets_user_purchased = Ticket.where(user_id: @user)

    genre_purchased_tickets = tickets_user_purchased.map do |ticket|
      ticket.movie.genre
    end

    x = genre_purchased_tickets.max_by {|genre| genre_purchased_tickets.count(genre)}
    puts "Your favorite genre is: #{x}"
    
    profile_menu
    end

  def self.most_visited_theater
    tickets_user_purchased = Ticket.where(user_id: @user)

    location_purchased_tickets = tickets_user_purchased.map do |ticket|
      ticket.location.name
    end

    x = location_purchased_tickets.max_by {|location| location_purchased_tickets.count(location)}
    puts "Your most visited theater is: #{x}"

    profile_menu
  end

  def self.movies_history
    tickets_user_purchased = Ticket.where(user_id: @user)
    
    title_purchased_tickets = tickets_user_purchased.map do |ticket|
      ticket.movie.title
    end
    puts "List of movies you've seen:"
    puts title_purchased_tickets.uniq

    profile_menu
  end

  def self.exit
    puts @a.asciify("Thank you").red
    puts @a.asciify("for using")
    puts @a.asciify("Movie App!").red
  end
  
  welcome_frame
end

