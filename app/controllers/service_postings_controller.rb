class ServicePostingsController < ApplicationController
  before_action :set_service_posting, only: [:show, :edit, :update, :destroy]

  layout "second_shift_pages"

  # # GET /service_postings
  # def index
  #   @service_postings = ServicePosting.all
  # end

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

  # DELETE /service_postings/1
  def destroy
    @service_posting.destroy
    redirect_to service_postings_url, notice: 'Service posting was successfully destroyed.'
  end

  ### Additional non-restful actions:

  def mine
  end

  def available
  end

  def wanted
  end

  def search
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_posting
      @service_posting = ServicePosting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def service_posting_params
      params.require(:service_posting).permit(:postingType, :summary, :description, :fullTimeEquivalents, :userId_id, :closed)
    end
end
