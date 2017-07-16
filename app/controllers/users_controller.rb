class UsersController < ApplicationController
   before_action :is_logged_in?, only: [:edit, :update, :destroy]

   def new
      @user = User.new()
   end

   def show
      @user = User.find(params[:id])
      @events = @user.events
   end

   def edit
      # FIXME: 自分自身しか編集できないようにする(update, destroyも同様)
      @user = User.find(params[:id])
   end

   def create
      @user = User.new(user_params)
      if @user.save
         flash['success'] = "ユーザー登録が完了しました"
         redirect_to(dashboard_url)
      else
         flash['danger'] = "入力情報に不備があります"
         render 'users/new'
      end
   end

   def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
         binding.pry

         flash['success'] = "ユーザー情報を更新しました"
         redirect_to(user_url(current_user))
      else
         flash['danger'] = "入力情報不備があります"
         render 'users/edit'
      end
   end

   def destroy
      @user = USer.find(params[:id])
      if @user.destroy
         flash['info'] = "ユーザー情報を削除しました"
      else
         flash['danger'] = "ユーザー情報を削除できません"
      end
      redirect_to(dashboard_url)
   end

   private
      def user_params
         params.require(:user).permit(:name, :email, :information, :password, :password_confirmation, :agreement)
      end

end
