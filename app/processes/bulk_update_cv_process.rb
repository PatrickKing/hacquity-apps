

# I didn't want to store transient state about the bulk upload process on either the record (which is database backed and mostly for informing the user about what's going on) or the delayedjob object (which is also database backed and really just for delayedjob's use). To avoid any possiblity of storing stale data, this object exists only while we're doing work.
class BulkUpdateCvProcess

  def initialize (bulk_update_record)
    @bulk_update_record = bulk_update_record
  end

  def run


    # download the ZIP
      # errors: zip not found, couldn't save file or something
    # unzip the zip
      # errors: disk space? file not found? disk unzip util not there?
    # find the CSV, read it
      # errors: no CSV, can't read CSV, more than 1 CSV
    # ensure each line item record exists
      # per item errors: ... ?
    # per line item: 
      # locate user,
      # locate file,
      # call the CV upload process, 
      # update line item with the results
    # done! set completed statuses

    # TODO: verify that throwing an exception here causes the bulk update job to fail and retry. 

  end

  private


end








