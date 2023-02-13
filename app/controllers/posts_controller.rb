class PostsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]

    def index
      if params[:search] == nil
        @posts= Post.all
      elsif params[:search] == ''
        @posts= Post.all
      else
        #部分検索
        search = params[:search]
        @posts = Post.where("name LIKE ? OR station LIKE ?OR address LIKE ?OR time LIKE ?OR about LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
      end
        if params[:tag_ids]
        @posts = []
        params[:tag_ids].each do |key, value|
            @posts += Tag.find_by(name: key).posts if value == "1"
        end
        @posts.uniq!
    end
    #以下を追記
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
    #ここまで

      if params[:tag]
        Tag.create(name: params[:tag])
      end

    end

    def new
        @post = Post.new
    end
    
    def create
        post = Post.new(post_params)
        
        post.user_id = current_user.id
        
        if post.save!
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
    end
    
    def show
      @post = Post.find(params[:id])
      @comments = @post.comments
      @comment = Comment.new
    end

    def edit
      @post = Post.find(params[:id])
    end

    def update
      post = Post.find(params[:id])
      if post.update(post_params)
        redirect_to :action => "show", :id => post.id
      else
        redirect_to :action => "new"
      end
    end

    def destroy
      post = Post.find(params[:id])
      post.destroy
      redirect_to action: :index
    end

      private
    def post_params
        params.require(:post).permit(:name, :station, :address, :time, :about, :image, :lat, :lng, tag_ids: [])
    end

end
