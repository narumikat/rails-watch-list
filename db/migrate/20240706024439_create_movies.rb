class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :overview
      t.string :poster_url
      t.string :backdrop_path
      t.decimal :rating

      t.timestamps
    end
  end
end
