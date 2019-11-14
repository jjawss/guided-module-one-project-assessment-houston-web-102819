#ActiveRecord::Base.logger = nil
require_relative '../config/environment'


class MovieApp

    #METHODS FOR WELCOME AND MAIN MENU-------------------------------------
    
    attr_accessor :user, :prompt, :main_menu_choice, :movie_menu_choice, :location_menu_choice, :time_menu_choice
    @prompt = TTY::Prompt.new

    def self.welcome
        puts "Welcome to Movie App!"
        puts "What is your name?"
        current_name = gets.chomp

        check_or_create(current_name)
    end

    def self.check_or_create(current_name)
        @user = User.find_by({ name: current_name })
        if @user == nil
          @user = User.create(name: "#{current_name}")
        end
        main_menu
    end
             
    def self.main_menu
        @main_menu_choice = @prompt.select("Hello, #{@user.name}, What would you like to do?", ["Select a movie", "View my profile"])
        if @main_menu_choice == "Select a movie"
            movie_menu
        elsif @main_menu_choice == "View my profile"
            profile_menu
        end
    end

    def self.profile_menu
        @profile_menu_choice = @prompt.select("Welcome to your profile.", ["Update user name", "Delete user", "Favorite Genre", "Favorite Theater", "My Movie List", "BACK"])

        if @profile_menu_choice == "Update user name"
            update_user
        elsif @profile_menu_choice == "Delete user"
            delete_user
        elsif @profile_menu_choice == "Favorite Genre"
            favorite_genre
        elsif @profile_menu_choice == "Favorite Theater"
            most_visited_theater
        elsif @profile_menu_choice == "My Movie List"
            movies_history
        elsif @profile_menu_choice == "BACK"
            main_menu
        end
    end

    #METHODS FOR PROFILE BRANCH------------------------------

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
        puts "Your favorite genre is: #{x}."
        
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

    #METHODS FOR MOVIE BRANCH------------------------------------------------------

    def self.movie_menu
        movie_titles = Movie.all.map do |movie|
            movie.title
        end
        
        @movie_menu_choice = @prompt.select("Select a movie:", [movie_titles, "BACK"])

        if @movie_menu_choice == "BACK"
            main_menu 
        else
            location_menu
        end
    end

    def self.location_menu
        location_names = Location.all.map do |location|
            location.name
        end

        @location_menu_choice = @prompt.select("Select a location:", [location_names, "BACK"])

        if @location_menu_choice == "BACK"
            movie_menu
        else
            time_menu
        end
    end

    def self.time_menu
        movie_object = Movie.where(title: @movie_menu_choice)
        location_object = Location.where(name: @location_menu_choice)
        tickets_for_movie_location_object = Ticket.where(movie: movie_object, location: location_object)

        ticket_labels = {}
        tickets_for_movie_location_object.each do |ticket|
            ticket_labels["Time: #{ticket.time} Price: $#{ticket.price}"] = ticket
        end

        @time_menu_choice = @prompt.select("Select a time:", [ticket_labels, "BACK"])
        
        @time_menu_choice.user = @user
        @time_menu_choice.save
        
        if @time_menu_choice == "BACK"
            location_menu
        else
            confirmation_screen
        end

        
    end
        
    def self.confirmation_screen
        "You're going to #{@time_menu_choice.location.name} to see #{@time_menu_choice.movie.title} at #{@time_menu_choice.time}."
    end



    



    # TEST RUNNING APP ------------------------------


    p welcome
end









