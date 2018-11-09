class VendorReviewsController < ApplicationController

  before_action :require_user_login

  before_action :set_vendor_review, only: [:show, :edit, :update, :destroy, :set_vendor_review, :set_vendor_review, :like, :unlike, :neutral_helpfulness]

  before_action :require_owner, only: [:edit, :update, :destroy]

  before_action :set_vendor_review_like, only: [:like, :unlike, :neutral_helpfulness]

  layout 'trusted_vendors_pages'

  def index
    @vendor_reviews = VendorReview
      .order(updated_at: :desc)
      .page(params[:page])
  end

  def show
  end

  def new
    @vendor_review = VendorReview.new
  end

  def edit
  end

  def create
    @vendor_review = VendorReview.new(vendor_review_params)
    @vendor_review.user = current_user

    if @vendor_review.save
      redirect_to vendor_review_path(@vendor_review), notice: 'Vendor review was successfully created.'
    else
      render :new
    end
  end

  def update
    if @vendor_review.update(vendor_review_params)
      redirect_to vendor_review_path(@vendor_review), notice: 'Vendor review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vendor_review.destroy
    redirect_to mine_vendor_reviews_url, notice: 'Vendor review was successfully destroyed.'
  end

  # Non RESTful actions

  def mine
    @vendor_reviews = VendorReview
      .where(user: current_user)
      .order(updated_at: :desc)
      .page(params[:page])
  end

  def search
    @vendor_reviews = VendorReview
      .order(updated_at: :desc)
      .search(params[:query])
      .page(params[:page])
  end

  def query
    redirect_to search_vendor_reviews_path(query: params[:query])
  end

  # TODO: error handling on like/unlike
  def like
    if @vendor_review_like.helpfulness == -1
      @vendor_review.likes += 2
      @vendor_review.save!
    elsif @vendor_review_like.helpfulness == 0
      @vendor_review.likes += 1
      @vendor_review.save!
    end

    @vendor_review_like.helpfulness = 1
    @vendor_review_like.save!
    redirect_to request.referrer or @vendor_review
  end

  def unlike
    if @vendor_review_like.helpfulness == 1
      @vendor_review.likes -= 2
      @vendor_review.save!
    elsif @vendor_review_like.helpfulness == 0
      @vendor_review.likes -= 1
      @vendor_review.save!
    end

    @vendor_review_like.helpfulness = -1
    @vendor_review_like.save!
    redirect_to request.referrer or @vendor_review
  end

  def neutral_helpfulness
    if @vendor_review_like.helpfulness == 1
      @vendor_review.likes -= 1
      @vendor_review.save!
    elsif @vendor_review_like.helpfulness == -1
      @vendor_review.likes += 1
      @vendor_review.save!
    end

    @vendor_review_like.helpfulness = 0
    @vendor_review_like.save!
    redirect_to request.referrer or @vendor_review
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vendor_review
    @vendor_review = VendorReview.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def vendor_review_params
    params.require(:vendor_review).permit(:title, :body, :vendor_name, :vendor_address_line1, :vendor_address_line2, :vendor_email_address, :vendor_phone_number, :vendor_contact_instructions, :vendor_services)
  end

  def set_vendor_review_like
    @vendor_review_like = @vendor_review.vendor_review_likes.where(user_id: current_user.id).first_or_create()
  end

  def require_owner
    unless current_user == @vendor_review.user
      redirect_to @vendor_review, notice: 'You must be the author of the review to do that.'
    end
  end
end
