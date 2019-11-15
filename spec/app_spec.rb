describe(MovieApp) do 

  # it('should have a movie_titles method') do 
  #   expect(MovieApp.movie_titles.class).to(eq(Array))
  #   expect(MovieApp.movie_titles.first.class).to(eq(String))
  # end

  it('should have a movie_titles method') do 
    expect(MovieApp.movie_titles.class).to(eq(Array))
    expect(MovieApp.movie_titles.first.class).to(eq(String))
  end

  it ('should have a location names method') do 
    expect(MovieApp.location_names.class).to(eq(Array))
    expect(MovieApp.location_names.first.class).to(eq(String))
  end

  # it ('should have a movie times method') do
  #   expect(MovieApp.movie_times(:users_location).class).to(eq(Array))
  #   expect(MovieApp.movie_times(:users_location).first.class).to(eq(String))
  #end
end