# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'
require 'json'

def fetch_movies(page)
  api_key = "bf024e341468ce68a262cb311d8701b9"
  url = "https://api.themoviedb.org/3/movie/top_rated?api_key=#{api_key}&page=#{page}&append_to_response=videos,images"
  response = URI.open(url).read 
  JSON.parse(response)['results']
end

# Coletar filmes das primeiras 10 páginas
movies = []
(1..10).each do |page|
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
