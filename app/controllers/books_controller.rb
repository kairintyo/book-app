class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_authenticate, only: [:edit, :update]

  def index
    @books = Book.all
    @book = current_user.books.new
    @user = User.find(current_user.id)
  end

  def create
    @user = User.find(current_user.id)
    @books = Book.all
    @book = @user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book)
      flash[:success] = 'successfully'
    else
      flash.now[:danger] = "#{@book.errors.full_messages.count}error"
      render "books/index"
    end
  end

  def show
    @book1 = Book.find(params[:id])
    @user = User.find(@book1.user_id)
    @book = current_user.books.new
  end
  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id)
      flash[:success] = 'successfully'
    else
      flash.now[:danger] = "#{@book.errors.full_messages.count}error"
      render :edit
    end

  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end

  def user_authenticate
    book = Book.find(params[:id])
    user = User.find(book.user_id)
    redirect_to books_path unless user == current_user
  end
end
