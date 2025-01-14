class MoviesController < ApplicationController
  def create
    max_id = Movie.maximum(:id)
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE movies_id_seq RESTART WITH #{max_id.to_i + 1}")

    new_movie = Movie.new
    new_movie.title = params.fetch("query_title")
    new_movie.year = params.fetch("query_year")
    new_movie.duration = params.fetch("query_duration")
    new_movie.description = params.fetch("query_description")
    new_movie.image = params.fetch("query_image")
    new_movie.director_id = params.fetch("query_director_id")
    new_movie.save

    redirect_to("/movies")
  end

  def destroy
    the_id = params.fetch("path_id")
    the_record = Movie.find(the_id)
    the_record.destroy
    redirect_to("/movies")
  end

  def update
    the_id = params.fetch("path_id")
    the_record = Movie.find(the_id)
    the_record.name = params.fetch("query_name")
    the_record.dob = params.fetch("query_dob")
    the_record.bio = params.fetch("query_bio")
    the_record.image = params.fetch("query_image")
    the_record.save

    redirect_to("/movies/#{the_id}")
  end

  def index
    matching_movies = Movie.all
    @list_of_movies = matching_movies.order({ :created_at => :desc })

    render({ :template => "movie_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_movies = Movie.where({ :id => the_id })
    @the_movie = matching_movies.at(0)

    render({ :template => "movie_templates/show" })
  end
end
