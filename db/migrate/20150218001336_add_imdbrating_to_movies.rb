class AddImdbratingToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :imdbrating, :string
  end
end
