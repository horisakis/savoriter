class AuthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_auth, only: %i[edit update destroy]

  def index
    @auths = Auth.where(user_id: current_user.id)
  end

  def edit; end

  def update
    respond_to do |format|
      if @auth.update(auth_params)
        format.html { redirect_to auths_path, notice: '連携情報を更新しました。' }
        format.json { render :index, status: :ok, location: @auth }
      else
        format.html { render :edit }
        format.json { render json: @auth.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @auth.destroy
    respond_to do |format|
      format.html { redirect_to auths_path, notice: '連携情報を削除しました。' }
      format.json { head :no_content }
    end
  end

  private

  def set_auth
    @auth = Auth.find(params[:id])
  end

  def auth_params
    params.require(:auth).permit(:destination, :save_path)
  end
end
