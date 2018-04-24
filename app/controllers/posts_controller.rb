class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  respond_to :html
  
  def index
    @posts = Post.all
    @post_img = @posts
  end

 
  def show
    respond_with(@post)
  end


  def new
    @post = current_user.posts.build
  end

 
  def
  
   edit
   
  end

 
  def create
    @post = current_user.posts.build(post_params)
   if @post.save
    redirect_to @post, notice: 'Post was sucessfully created.'
   else
    render action: 'new'
   end
  end

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
      end
    end
  
  def update
     
    if @post.update(post_params)
        redirect_to @post, notice: 'Post was sucessfully updated'.
    else
        render action: 'edit'
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_url
  end
  
private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.required(:post).permit(:body, :image, :name)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_path, notice: "Not authorized to edit this post." if @post.nil?
    end

end

 