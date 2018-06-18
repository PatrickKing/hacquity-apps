class ServicePostingsController < ApplicationController
  before_action :require_login

  before_action :set_service_posting, only: [:show, :edit, :update, :destroy]

  layout "second_shift_pages"

  # GET /service_postings/1
  def show
  end

  # GET /service_postings/new
  def new
    @service_posting = ServicePosting.new
  end

  # GET /service_postings/1/edit
  def edit
  end

  # POST /service_postings
  def create
    @service_posting = ServicePosting.new(service_posting_params)
    @service_posting.user = current_user

    if @service_posting.save
      redirect_to @service_posting, notice: 'Service posting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /service_postings/1
  def update
    if @service_posting.update(service_posting_params)
      redirect_to @service_posting, notice: 'Service posting was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @service_posting.destroy
    redirect_to service_postings_url, notice: 'Service posting was successfully destroyed.'
  end

  ### Additional non-restful actions:

  def mine
    @service_postings = ServicePosting.where user: current_user
  end

  def available
    @service_postings = ServicePosting.where closed: false, posting_type: 'Available'
  end

  def wanted
    @service_postings = ServicePosting.where closed: false, posting_type: 'Wanted'
  end

  def search
  end


  def close
    @service_posting.closed = true
    redirect_to @service_posting, notice: 'The service posting was closed, and is no longer visible to the public.'
  end

  def open
    @service_posting.closed = false
    redirect_to @service_posting, notice: 'The service posting was re-opened, and is again visible to the public.'
  end



  private
    def set_service_posting
      @service_posting = ServicePosting.find(params[:id])
    end

    def service_posting_params
      params.require(:service_posting).permit(:posting_type, :summary, :description, :full_time_equivalents, :service_type)
    end
end
