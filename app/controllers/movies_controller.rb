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
    # By default, all ratings appear
    @all_ratings = ["G","PG","PG-13","R"]
   
    # if this is the user's first time accessing the page, session[:ratings]
    # will be empty and thus needs to have the full list put into it so that
    # all movies show up
    if(!session[:ratings])
      session[:ratings] = @all_ratings
    end
   
    # Takes ratings_choice from params based on what the user does
    @ratings_choice = params[:ratings]
    
    # If there is nothing in ratings_choice, that means the user
    # attempted a search with no ratings. In this case, the
    # value of ratings_choice is taken from the last valid session
    if(!@ratings_choice)
      @ratings_choice = session[:ratings]
    end
    
    # Saves the values of ratings_choice in case the user leaves the page
    session[:ratings] = @ratings_choice
    
    # Takes sort_by from params based on what the user does
    @sort_by = params[:sort]
    
    # Gets sort from session if nothing is in sort_by
    if(!@sort_by)
      @sort_by = session[:sort]
    end
    
    # Saves the values of sort_by in case the user leaves the page
    session[:sort] = @sort_by
    
    # Displays movies according to specifications
    @movies = Movie.where(rating: @ratings_choice.keys).order(@sort_by)
    
    #if(!params[:ratings] and !session[:ratings])
      #flash.keep
      #redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    #end
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
