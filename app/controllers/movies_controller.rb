class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    temp_ratings = params[:ratings]
    if temp_ratings.nil?
      if session[:selected_ratings].nil?
        temp_ratings = @all_ratings
      else
        temp_ratings = session[:selected_ratings]
      end
    else
      temp_ratings = temp_ratings.keys
    end
    @selected_ratings = temp_ratings
    session[:selected_ratings] = temp_ratings
    @title_class = ""
    @date_class = ""
    @movies = Movie.where({rating: [@selected_ratings]})
    sort = nil
    if params.has_key?(:sort)
      sort = params[:sort].to_sym
    elsif not session[:sort].nil?
      sort = session[:sort].to_sym
    end
    if not sort.nil?
        session[:sort] = sort
      if sort == :title
        @title_class = "hilite"
        @movies = @movies.order(:title)
      elsif sort == :release_date
        @date_class = "hilite"
        @movies = @movies.order(:release_date)
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
