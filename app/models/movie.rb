class Movie < ActiveRecord::Base
  require 'csv'
  require 'open-uri'

  # after_find :response

  scope :ordered, -> { order("case when imdbrating == 'N/A' then -1 else imdbrating end desc" ) }

  # def response
  #   response = HTTParty.get("http://www.omdbapi.com/", @options = { query: {t: self.title, y: self.year} })
  #   parsed = JSON.parse(response)
  #   imdb_rating = parsed["imdbRating"]
  #   self.update_attributes(imdbrating: imdb_rating)
  # end

  def self.get_imdbrating
    OmdbRequestWorker.perform_async(@movie.id)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: false, :encoding => 'utf-8') do |row|
      movie_row = row.collect! { |r| r.gsub(/"/,'').strip unless r.nil? }
      sql = "INSERT INTO movies ('title', 'year') VALUES (#{ movie_row.map { |i| '"'+ i.to_s + '"' }.join(",") })"
      ActiveRecord::Base.connection.execute sql
    end
  end

end
