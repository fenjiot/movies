class MoviesController < ApplicationController
  def index
    @movies = Movie.all.get_imdbrating
      respond_to do |format|
        format.html
        format.xml { render xml: @movies }
        format.json { render json: @movies.to_json }
      end
    @movie = Movie.find(params[:movie_id])
  end

  def import
    Movie.import(params[:file])
    redirect_to root_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :year, :imdbrating)
  end
end
