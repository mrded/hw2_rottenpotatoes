class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def goto(type, arg)
  #   
  # end

  def index
    # session.delete(:order)
    
    if request.GET[:order]
      session[:order] = request.GET[:order]
    elsif !session[:order]
      session[:order] = 'title'
    end
    
    # TODO: For submit forms use params instead GET.
    if (params[:ratings].is_a?(Hash)) 
      session[:ratings] = params[:ratings]
    elsif (!session[:ratings].is_a?(Hash))
      session[:ratings] = {'G' => true, 'PG' => true, 'R' => true, 'PG-13' => true}
    end
    
    if (!request.GET[:order])
      flash.keep
      redirect_to :controller => 'movies', :order => session[:order]  
    end
    
    
    # redirect_to request.url + "?hello='hello'"
      
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    @header = {
      'title'        => view_context.link_to("Movie Title", params.merge(:order => 'title'), {:id => 'title_header'}),
      'rating'       => 'Rating',
      'release_date' => view_context.link_to("Release Date", params.merge(:order => 'release_date'), {:id => 'release_date_header'}),
      'link'         => 'More Info',
    }
    
    if (session[:ratings].empty?)
      @movies = Movie.find(:all, :order => session[:order])
    else
      @movies = Movie.where(:rating => session[:ratings].keys).find(:all, :order => session[:order])
    end
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
