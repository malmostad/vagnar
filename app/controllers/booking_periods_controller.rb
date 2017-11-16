class BookingPeriodsController < ApplicationController
  before_action :set_booking_period, only: [:show, :edit, :update, :destroy]

  def index
    @booking_periods = BookingPeriod.all
  end

  def show
  end

  def new
    @booking_period = BookingPeriod.new
  end

  def edit
  end

  def create
    @booking_period = BookingPeriod.new(booking_period_params)

    if @booking_period.save
      redirect_to booking_periods_path, notice: 'Bokningsperioden skapades skapades'
    else
      render :new
    end
  end

  def update
    if @booking_period.update(booking_period_params)
      redirect_to booking_periods_path, notice: 'Bokningsperioden uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @booking_period.destroy
    redirect_to booking_periods_path, notice: 'Bokningsperioden togs bort'
  end

  private

    def combine_datetimes
      bpp = params[:booking_period]

      params[:booking_period][:booking_starts_at] = "#{bpp[:booking_date_starts_at]} #{bpp[:booking_time_starts_at]}"
      params[:booking_period][:booking_ends_at] = "#{bpp[:booking_date_ends_at]} #{bpp[:booking_time_ends_at]}"

      %i[booking_date_starts_at booking_time_starts_at booking_date_ends_at booking_time_ends_at].each do |field|
        params[:booking_period].delete(field)
      end
    end

    def set_booking_period
      @booking_period = BookingPeriod.find(params[:id])
    end

    def booking_period_params
      combine_datetimes
      params.require(:booking_period).permit(
        :starts_at,
        :ends_at,
        :booking_starts_at,
        :booking_ends_at,
      )
    end
end
