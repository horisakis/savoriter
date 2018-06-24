class AuthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_auth, only: %i[edit update destroy]

  # GET /auths
  # GET /auths.json
  def index
    @auths = Auth.where(user_id: current_user.id)
  end

  # GET /auths/1/edit
  def edit; end

  # PATCH/PUT /auths/1
  # PATCH/PUT /auths/1.json
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

  # DELETE /auths/1
  # DELETE /auths/1.json
  def destroy
    @auth.destroy
    respond_to do |format|
      format.html { redirect_to auths_path, notice: '連携情報を削除しました。' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_auth
    @auth = Auth.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def auth_params
    params.require(:auth).permit(:destination, :save_path)
  end
end
