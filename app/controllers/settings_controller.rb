# Simle key value settings. Key and human name is set in console
class SettingsController < ApplicationController
  def index
    @settings = Setting.all
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update(setting_params)
      redirect_to settings_path, notice: 'Inställningen uppdaterades'
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:value)
  end
end
