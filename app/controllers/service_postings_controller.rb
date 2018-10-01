class ServicePostingsController < ApplicationController
  before_action :require_user_login

  before_action :set_service_posting, only: [:show, :edit, :update, :open, :close]
  before_action :require_ownership, only: [:edit, :update, :open, :close]

  layout "second_shift_pages"

  def show
  end

  def new
    @service_posting = ServicePosting.new
  end

  def edit
  end

  def create
    @service_posting = ServicePosting.new(service_posting_params)
    @service_posting.user = current_user

    if @service_posting.save
      redirect_to @service_posting, notice: 'Service posting was successfully created.'
    else
      render :new
    end
  end

  def update
    if @service_posting.update(service_posting_params)
      redirect_to @service_posting, notice: 'Service posting was successfully updated.'
    else
      render :edit
    end
  end


  ### Additional non-restful actions:

  def mine
    @service_postings = ServicePosting
      .where(user: current_user)
      .page(params[:page])
  end

  def available
    @service_postings = ServicePosting
      .where(closed: false, posting_type: 'Available')
      .page(params[:page])
  end

  def wanted
    @service_postings = ServicePosting
      .where(closed: false, posting_type: 'Wanted')
      .page(params[:page])
  end

  def search
  end


  def close
    @service_posting.closed = true
    @service_posting.save!
    redirect_to @service_posting, notice: 'The service posting was closed, and is no longer visible to the public.'
  end

  def open
    @service_posting.closed = false
    @service_posting.save!
    redirect_to @service_posting, notice: 'The service posting was re-opened, and is again visible to the public.'
  end



  private
    def set_service_posting
      @service_posting = ServicePosting.find(params[:id])
    end

    def service_posting_params
      params.require(:service_posting).permit(:posting_type, :summary, :description, :full_time_equivalents, :service_type)
    end

    def require_ownership
      if @service_posting.user != current_user
        flash[:notice] = 'You need to be the creator of the posting to do that.'
        redirect_to request.referer || @service_posting
      end
    end
end
