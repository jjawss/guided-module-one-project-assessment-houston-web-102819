describe(MovieApp) do 

  it('should have a movie_titles method') do 
    expect(MovieApp.movie_titles.class).to(eq(Array))
    expect(MovieApp.movie_titles.first.class).to(eq(String))
  end

  it('should have a locations method') do
    expect(MovieApp.movie_titles.class).to(eq(Array))
    expect(MovieApp).movie_title.class).to(eq(String))
  end

  it('should have a movie time method') do
    expect(MovieApp.movie_times.class).to(eq "Time: #{ticket.time} Price: $#{ticket.price}0")
    expect(MovieApp).movie_times.class).to(eq(String)
  end

end