

class BulkUpdateCvJob

  def initialize (bulk_update_record)
    @bulk_update_record_id = bulk_update_record.id
  end

  def process
    BulkUpdateCvProcess.new(BulkUpdateRecord.find @bulk_update_record_id).run
  end

  handle_asynchronously :process

end








