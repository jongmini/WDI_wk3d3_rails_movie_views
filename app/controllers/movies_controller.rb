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

    search_str = params[:movie]

    result = Typhoeus.get("http://www.omdbapi.com/", :params => {:s => search_str})
    movies = JSON.parse(result.body)
    # setting the class variable to use for matching
    @@result_movies = movies["Search"]

    @movie_list =[]
    movies["Search"].each { |mov| @movie_list << [mov["Title"],mov["Year"],mov["imdbID"]] }
    @movie_list.sort!{|x,y| y[1] <=> x[1]} 

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


  def create # I wanted to connect create to search on omdbapi but ran out of time. 
    movie = params.require(:movie).permit(:title, :year)
    movie["imdbID"] = rand(10000..100000000).to_s
    new_movie = Movie.create(movie)
    binding.pry
    redirect_to action: :index
  end

  # route: PATCH  /movies/:id(.:format)
  def update
    id = params[:id]

    movie = Movie.find_by imdbID: id

    updated_movie = params.require(:movie).permit(:title, :year)
    movie.update_attributes(updated_movie)
    redirect_to "/movies/#{movie.imdbID}"
  end

  # route: DELETE /movies/:id(.:format)
  def destroy
    id = params[:id]
    monster = Movie.find_by imdbID: id
    # movie["imdbID"] = id
    monster.destroy
    redirect_to action: :index
  end

  

  def add_movies
    @movie_selected = []
    movies = params[:imdbID]

    movies.each do |movID|
      # match the chosen movie imdbIDs with the original results
      if @@result_movies.map do |mov| 
        if mov["imdbID"].include?(movID)

        Movie.create({"title" => mov["Title"], "year" => mov["Year"], "imdbID" => mov["imdbID"]})

        @movie_selected << (Movie.find_by imdbID: movID)
        end
      end
      end
    end
    
    render :added

  end
 

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
