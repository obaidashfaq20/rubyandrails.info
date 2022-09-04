class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show edit update destroy]

  def index
    @authors = Author.all.order("name DESC") 
    @tags = Tag.all.order(:title)

    set_meta_tags title: "#{Author.count} authors writing about Ruby & Ruby on Rails", description: "People who write books about Ruby and Ruby on Rails. For each author you can see all the books they have written about the topic and their contacts: twitter, website, or github.", keywords: "Ruby book authors, Ruby on Rails book authors"
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new author_params
    if @author.save
      redirect_to authors_path
    else
      render :new
    end
  end

  def show
    @books = Book.joins(:authors).where(authors: { id: @author })
    @courses = Course.joins(:authors).where(authors: { id: @author })
    @screencasts = Screencast.joins(:authors).where(authors: { id: @author })

    set_meta_tags title: "Author: #{@author.name}", description: "#{@author.name} author of #{@books.map { |book| book.title }.join(", ").html_safe}.", keywords: "#{@author.name}, #{@books.map { |book| book.title }.join(", ").html_safe}"
    # show all tags from books current author
    #@writes = Book.includes(:authors).all 
  end

  def edit
  end

  def update
    if @author.update author_params
      redirect_to author_path
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_path
  end

  private

  def set_author
    @author = Author.friendly.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :content, :twitterUrl, :siteUrl, :githubUrl, )
  end
end
