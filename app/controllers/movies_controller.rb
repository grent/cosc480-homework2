# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index

	#redirect to previous session settings if new sort and ratings parameters aren't specified
	if params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[ratings].nil?)
		flash.keep
		redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
	end

	@sort = params[:sort]
	@ratings = params[:ratings]

	#default to all ratings
	if @ratings.nil?
		ratings = Movie.ratings
	else
		ratings = @ratings.keys
	end

	#making the all_ratings collection 
	@all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
          all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating) 
          all_ratings
        end

	#if the table should be sorted, it reorders the columns using the order method
	unless @sort.nil?
		@movies = Movie.order("#{@sort}").find_all_by_rating(ratings)
	else
		@movies = Movie.find_all_by_rating(ratings)
	end

	#save settings in session
	session[:sort] = @sort
	session[:ratings] = @ratings
  end






  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
