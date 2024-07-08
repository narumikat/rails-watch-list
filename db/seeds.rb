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
    backdrop_url: "https://image.tmdb.org/t/p/w500#{data["backdrop_url"]}"
  )
end

puts "Seeded #{movies.size} movies from TMDB API"

puts 'Creating lists...'

list_names = ["Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Documentary", "Fantasy", "Classic", "Super Hero"]

list_images = {
  "Action" => "https://img.freepik.com/fotos-gratis/paisagem-de-guerra-e-conflito-com-soldados-atirando_23-2149766342.jpg?t=st=1720323151~exp=1720326751~hmac=825ca6e7abcf97cfe9b4633e552c3daa8863f1f20b06a9298a9842889c7a8786&w=2000",
  "Comedy" => "https://img.freepik.com/fotos-gratis/amigos-assistindo-filme-no-cinema_23-2147803785.jpg?t=st=1720323226~exp=1720326826~hmac=0eafa514689c869ab288ded17c97d7a9cb9009a8b1324adee10fe113bfb2a837&w=2000",
  "Drama" => "https://img.freepik.com/fotos-gratis/encantadora-mulher-atraente-andando-com-jovem-na-rua_23-2148012592.jpg?t=st=1720323308~exp=1720326908~hmac=2ec38ae86481269534cdcf340b2763f93fe5a52b01a0a2f9c1d6d2beb8e6122b&w=2000",
  "Horror" => "https://img.freepik.com/fotos-gratis/retrato-de-palhaco-assustador_23-2150549660.jpg?t=st=1720323369~exp=1720326969~hmac=af4160972ab9f1ec02af489697bbd3f82634a23f1fb54ffceeb5e18e380b1c5b&w=2000",
  "Sci-Fi" => "https://img.freepik.com/fotos-gratis/desenho-de-colagem-de-viagem-espacial_23-2150163734.jpg?t=st=1720323409~exp=1720327009~hmac=d37106ea97712dd7830252a5bbee6a12e3e4cebc4df971ebb82e16674a7a6d0e&w=2000",
  "Documentary" => "https://img.freepik.com/fotos-gratis/listras-negativas-com-claquete-bobinas-de-filme-bilhetes-e-pipoca-na-mesa-de-madeira_23-2148188185.jpg?t=st=1720323437~exp=1720327037~hmac=d5c04f742fde958d4911f0d010d4a78fee3914c2b043c557807a3989bc4b29a5&w=2000",
  "Fantasy" => "https://img.freepik.com/fotos-gratis/garota-de-vista-traseira-sentada-na-cadeira-no-trem_23-2149666784.jpg?t=st=1720323493~exp=1720327093~hmac=c94920c2d6b9641800ac184e754b628e9f2c7a4e024c426d7e2f7f4448bbdc1e&w=1800",
  "Classic" => "https://img.freepik.com/fotos-gratis/composicao-de-objetos-de-cinema-close-up_23-2148457830.jpg?t=st=1720323547~exp=1720327147~hmac=20a2740cc53f0cb25ece0454adfa878744a7801ff775e133aad19f4aec4bcb27&w=2000",
  "Super Hero" => "https://img.freepik.com/fotos-gratis/crianca-na-escola-de-magia-aprendendo-feiticos_23-2150170072.jpg?t=st=1720323395~exp=1720326995~hmac=784ddec9b86f44820396840edf1d1217ab806b0e5f03efafa26d5e3173bd56a0&w=2000"
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
  10.times do
    Review.create!(
      list: list,
      content: Faker::Quotes::Shakespeare.hamlet_quote,
      rating: rand(1..5)
    )
  end
end

puts 'Reviews created'

