class AdminBulkUpdateRecordController < ApplicationController

  before_action :require_admin_login

  layout 'admin_pages'

  # old: error or completed and >2 weeks old
  # new: created and in progress
  def index
    @bulk_update_records = BulkUpdateRecord.order(updated_at: :desc)
      .page(params[:page])
      .includes(:admin)
      .where """
      (status = 'created' or status = 'in_progress') or
      ((status = 'error_no_retry' or status = 'error_retry_permitted' or status = 'completed') and updated_at > :two_weeks_ago)
      """, two_weeks_ago: 2.weeks.ago
  end

  def new
    @bulk_update_record = BulkUpdateRecord.new

    # TODO: remove the ACL comment below once I'm sure I don't need it
    @s3_direct_post = S3_BUCKET.presigned_post key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201' #, acl: 'public-read'
  end

  def create
    @bulk_update_record = BulkUpdateRecord.new(record_params)
    @bulk_update_record.admin = current_admin

    if @bulk_update_record.save
      redirect_to bulk_cv_path(@bulk_update_record), notice: 'Bulk Update CV Job created.'
      BulkUpdateCvJob.new(@bulk_update_record).process
    else
      render :new
    end

  end

  def show
    @bulk_update_record = BulkUpdateRecord.find params[:id]
  end

  # Non RESTful actions:

  def rerun
    
  end

  private

  def record_params
    params.require('bulk_update_record').permit('s3_zip_id')
  end

end