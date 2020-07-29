class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]} #ログアウト中の制限
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]} #ログイン中の制限
  before_action :ensure_correct_user, {only: [:edit, :update]} #直接編集に行けないようにする# ensure_correct_userを定義
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: "default_use3.jpg",
       # params[:password]をnewメソッドの引数に追加
      password: params[:password]
      )
    if @user.save
      # 登録されたユーザーのidを変数sessionに代入 ユーザー登録時にログイン状態に
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    # 画像を保存する処理を追加
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def login_form
  end
  
  def login
    # 入力内容と一致するユーザーを取得し、変数@userに代入
    @user = User.find_by(
      email: params[:email],
      password: params[:password]
    )
    # @userが存在するかどうかを判定するif文を作成
    if @user
      # ユーザーを保持する為のsession機能追加
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
       # @error_messageを定義
      @error_message = "メールアドレスまたはパスワードが間違っています"
      
      # @emailと@passwordを定義
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
  
  def likes
     # 変数@userを定義
    @user = User.find_by(id: params[:id])
    
    # 変数@likesを定義
    @likes = Like.where(user_id: @user.id)
  end
  
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
