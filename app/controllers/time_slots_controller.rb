class TimeSlotsController < ApplicationController
  before_action :set_time_slot, only: [:show, :edit, :update, :destroy]

  def index
    @time_slots = TimeSlot.all
  end

  def show
  end

  def new
    @time_slot = TimeSlot.new
  end

  def edit
  end

  def create
    @time_slot = TimeSlot.new(time_slot_params)

    if @time_slot.save
      redirect_to time_slots_path, notice: 'Bokningstiden skapades'
    else
      render :new
    end
  end

  def update
    if @time_slot.update(time_slot_params)
      redirect_to time_slots_path, notice: 'Bokningstiden uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @time_slot.destroy
    redirect_to time_slots_path, notice: 'Bokningstiden togs bort'
  end

  private
    def set_time_slot
      @time_slot = TimeSlot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def time_slot_params
      params.require(:time_slot).permit(:from, :to)
    end
end
