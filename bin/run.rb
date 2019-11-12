require_relative '../config/environment'

class MovieApp

  attr_accessor :user

  prompt = TTY::Prompt.new

  # def check_or_create(name)
  #   user = User.find_by({ name: name })
  #   if user == nil
  #     return User.create(name: "#{name}")
  #   else
  #     return puts "Hello #{name}, what would you like to do?"
  #   end

    # User.all.each do |user_name|
    #     if user_name.name == name
    #     return puts "Hello #{name}, what would you like to do?"
    #     end
    #   end
    #   return User.create(name: "#{name}")
    # end

  def self.check_or_create(name)
    prompt = TTY::Prompt.new
    @user = User.find_by({ name: name })
    if @user == nil
      @user = User.create(name: "#{name}")
      return prompt.select("Hello, #{name}, what would you like to do?", ["Select a movie", "User options"])
    else
      return prompt.select("Hello, #{name}, what would you like to do?", ["Select a movie", "User options"])
    end
  end

  #-------------------------------------------------------

  #Frame 1
  puts "Welcome to Movie App!"

  puts "What is your name?"
  current_user = gets.chomp

  #Frame 2
  user_choice = check_or_create(current_user)


  movie_titles = Movie.all.map do |movie|
    movie.title
  end


  if user_choice == "Select a movie"
    users_movie = prompt.select("What movie would you like to see?", movie_titles)
  else 
    prompt.select("User Options", ["Update name", "Delete user"])
  end



  location_names = Location.all.map do |location|
    location.name
  end

  users_location = prompt.select("Select a location", location_names)


  movie_object = Movie.where(title: users_movie)
  location_object = Location.where(name: users_location)
  tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)

  ticket_labels = {}
  tickets_for_movie_location_object.each do |ticket|
    ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}"] = ticket
  end


  users_ticket = prompt.select("Select a time", ticket_labels)

  puts "You're going to #{users_ticket.location.name} to see #{users_ticket.movie.title} at #{users_ticket.time}."

  users_ticket.user = @user
  users_ticket.save

end








# current_user_object = User.where(name: current_user)

# users_ticket.user = current_user_object






