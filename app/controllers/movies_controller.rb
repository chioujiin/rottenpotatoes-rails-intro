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
    # @movies = Movie.all
    # @movies = Movie.order(params[:sort_by])
    # @sort_column = params[:sort_by]
    if params[:commit] == 'Refresh'
          session[:ratings] = params[:ratings]
    elsif session[:ratings] != params[:ratings]
          redirect = true
          params[:ratings] = session[:ratings]
    end

    if params[:order]
          session[:order] = params[:order]
    elsif session[:order]
          redirect = true
          params[:order] = session[:order]
    end
    @ratings, @order = session[:ratings], session[:order]
    if redirect
        redirect_to movies_path({:order=>@order, :ratings=>@ratings})
    end
    @all_ratings= Movie.all_ratings
    @selected_ratings= params[:ratings] ? params[:ratings].keys : @all_ratings
    @movies= Movie.where({rating:  @selected_ratings}).order(params[:order])
    
    
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
