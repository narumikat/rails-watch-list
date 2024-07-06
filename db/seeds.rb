require 'open-uri'
require 'json'

puts 'Cleaning database...'

Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts 'Creating movies...'

def fetch_movies(page)
  api_key = "bf024e341468ce68a262cb311d8701b9"
  url = "https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}&page=#{page}&append_to_response=videos,images"
  response = URI.open(url).read 
  JSON.parse(response)['results']
end

# Coletar filmes das primeiras 10 páginas
movies = []
(1..5).each do |page|
  movies.concat(fetch_movies(page))
end

movies.each do |data|
  Movie.create!(
    title: data["title"],
    overview: data["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{data["poster_path"]}",
    rating: data["vote_average"]
  )
end

puts "Seeded #{movies.size} movies from TMDB API"

puts 'Creating lists...'

list_names = ["Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Documentary", "Fantasy"]

list_names.each do |list_name|
  List.find_or_create_by!(name: list_name)
end

puts "Seeded #{list_names.size} lists"

puts 'Creating bookmarks...'

lists = List.all
movies = Movie.all.sample(20)

lists.each do |list|
  5.times do
    movie = movies.sample
    begin
      Bookmark.create!(
        list: list,
        movie: movie,
        comment: "This is a great #{list.name.downcase} movie!"
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Skipping duplicate bookmark for movie '#{movie.title}' in list '#{list.name}'"
    end
  end
end

puts "Seeded bookmarks"
