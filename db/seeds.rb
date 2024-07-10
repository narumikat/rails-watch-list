require 'open-uri'
require 'json'

puts 'Cleaning database...'

Review.destroy_all
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
(1..10).each do |page|
  page_movies = fetch_movies(page)
  puts "Fetched #{page_movies.size} movies from page #{page}"
  movies.concat(page_movies)
end

puts "Total movies fetched: #{movies.size}"

movies.each do |data|
  Movie.create!(
    title: data["title"],
    overview: data["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{data["poster_path"]}",
    rating: data["vote_average"],
    release_date: data["release_date"],
    backdrop_path: "https://image.tmdb.org/t/p/w500#{data["backdrop_path"]}"
  )
end

puts "Seeded #{movies.size} movies from TMDB API"

puts 'Creating lists...'

list_names = ["Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Documentary", "Fantasy", "Classic", "Super Hero"]

list_images = {
  "Action" => "https://images.unsplash.com/photo-1519021228607-ef6e4c22d821?q=80&w=3870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Comedy" => "https://images.unsplash.com/photo-1527224857830-43a7acc85260?q=80&w=3871&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Drama" => "https://images.unsplash.com/photo-1611673982064-7385a5d9574e?q=80&w=3870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Horror" => "https://images.unsplash.com/photo-1509248961158-e54f6934749c?q=80&w=3837&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Sci-Fi" => "https://plus.unsplash.com/premium_photo-1682124758854-e6e372888b85?q=80&w=3600&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Documentary" => "https://images.unsplash.com/photo-1611784728558-6c7d9b409cdf?q=80&w=2792&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Fantasy" => "https://images.unsplash.com/photo-1432958576632-8a39f6b97dc7?q=80&w=3873&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Classic" => "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?q=80&w=3870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "Super Hero" => "https://images.unsplash.com/photo-1501432377862-3d0432b87a14?q=80&w=3000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
}

list_images.each do |list_name, image_url|
  List.find_or_create_by!(name: list_name, image_url: image_url)
end


puts "Seeded #{list_names.size} lists"

puts 'Creating bookmarks...'

lists = List.all
movies = Movie.all.sample(20)

lists.each do |list|
  10.times do
    movie = movies.sample
    begin
      Bookmark.create!(
        list: list,
        movie: movie,
        comment: Faker::Lorem.sentence(word_count: 10, supplemental: false, random_words_to_add: 9)
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Skipping duplicate bookmark for movie '#{movie.title}' in list '#{list.name}'"
    end
  end
end

puts "Seeded bookmarks"

puts 'Creating reviews...'

lists = List.all
lists.each do |list|
  5.times do
    Review.create!(
      list: list,
      content: Faker::Quotes::Shakespeare.hamlet_quote,
      rating: rand(1..5)
    )
  end
end

puts 'Reviews created'

