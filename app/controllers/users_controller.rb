class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # パスワード変更首絞め中につき表示するものがないのでリダイレクト
    redirect_to authenticated_root_path
    @user = current_user
  end
end
