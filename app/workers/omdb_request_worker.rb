class OmdbRequestWorker
  include Sidekiq::Worker

  def perform(movie_id)
    response = HTTParty.get("http://www.omdbapi.com/", @options = { query: {t: movie_id.title, y: movie_id.year} })
    parsed = JSON.parse(response)
    imdb_rating = parsed["imdbRating"]
    self.update_attributes(imdbrating: imdb_rating)
  end
end
