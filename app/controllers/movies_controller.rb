class MoviesController < ApplicationController

  @@movie_db = [
          {"title"=>"The Matrix", "year"=>"1999", "imdbID"=>"tt0133093", "Type"=>"movie"},
          {"title"=>"The Matrix Reloaded", "year"=>"2003", "imdbID"=>"tt0234215", "Type"=>"movie"},
          {"title"=>"The Matrix Revolutions", "year"=>"2003", "imdbID"=>"tt0242653", "Type"=>"movie"}]

  # route: GET    /movies(.:format)

  def index
    # @movies = @@movie_db

    @movies = Movie.all

    respond_to do |format|
      format.html
      format.json { render :json => @@movie_db }
      format.xml { render :xml => @@movie_db.to_xml }
    end
  end

  def search



  end

  def results


  end


  # route: # GET    /movies/:id(.:format)
  def show
    @movie = get_movie params[:id]
  end

  # route: GET    /movies/new(.:format)
  def new
  end

  # route: GET    /movies/:id/edit(.:format)
  def edit
    @movie = get_movie params[:id]
# binding.pry
  end

  #route: # POST   /movies(.:format)
  # def create
  #   # create new movie object from params
  #   movie = params.require(:movie).permit(:title, :year)
  #   movie["imdbID"] = rand(10000..100000000).to_s
  #   # add object to movie db
  #   @@movie_db << movie
  #   # show movie page
  #   # render :index
  #   redirect_to action: :index
  # end

  def create
    movie = params.require(:movie).permit(:title, :year)
    movie["imdbID"] = rand(10000..100000000).to_s
    new_movie = Movie.create(movie)
    # movie["imdbID"] = new_movie.id
    # @@movie_db << movie
    redirect_to action: :index
  end

  # route: PATCH  /movies/:id(.:format)
  def update
    id = params[:id]

    movie = Movie.find_by imdbID: id
# binding.pry
    updated_movie = params.require(:movie).permit(:title, :year)
    movie.update_attributes(updated_movie)
    redirect_to "/movies/#{movie.imdbID}"
    #implement
    # update object in movies_db
    # render :show
    # render will stay within the same request - render will just show you a view in the same request
  end

  # route: DELETE /movies/:id(.:format)
  def destroy
    id = params[:id]
    monster = Movie.find_by imdbID: id
    # movie["imdbID"] = id
    monster.destroy
    redirect_to action: :index
  end

    #implement
    # delete movie from movies_db
    # redirect_to :index
    # redirect will take you back to the browser to create a second request for the server
    # redirect will refresh your database
  

  private  # private methods called from create and show

  def get_movie movie_id  # better not to create an instance variable at this level
    the_movie = Movie.find do |m|
      m["imdbID"] == params[:id]
    end

    if the_movie.nil?
      flash.now[:message] = "Movie not found"
      the_movie = {}
    end
    the_movie
  end

end
