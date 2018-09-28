

$(document).on 'turbolinks:load', ->

  $('#upload-button').on 'click', (event) ->
    event.preventDefault()
    fileInput = $ '#zip-file-input'
    fileInput.fileupload 'send', files: fileInput.prop('files')



  $('#s3_upload_form').find('input:file').each (i, elem) ->
    # TODO: do I really want to keep all this?

    fileInput = $ elem
    form = $ fileInput.parents 'form:first'
    submitButton = form.find 'input[type="submit"]'
    progressBar = $ '<div class="bar"> </div>'
    barContainer = $('<div class="progress"> </div>').append progressBar

    # We don't want this form to submit, just using it to contain a file submit element.
    form.on 'submit', (event) ->
      event.preventDefault()
      false


    fileInput.fileupload
      fileInput: fileInput
      url: form.data 'url'
      type: 'POST'
      autoUpload: false
      formData: form.data 'form-data'
      # S3 does not like nested name fields i.e. name="user[avatar_url]"
      paramName: 'file'
      # S3 returns XML if success_action_status is set to 201
      dataType: 'XML'
      replaceFileInput: false


      progressall: (e, data) ->
        progress = parseInt data.loaded / data.total * 100, 10
        progressBar.css 'width', progress + '%'

      start: (e) ->
        submitButton.prop 'disabled', true

        progressBar.
          css('background', '#5E35B1').
          css('display', 'block').
          css('width', '0%').
          text("Loading...")

      done: (e, data) ->
        progressBar.text "Uploading done"

        key = $(data.jqXHR.responseXML).find("Key").text()

        # set S3 file ID, submit the creation form
        $('#s3_zip_id_input').val key
        $('#bulk_update_cv_form').submit()


      fail: (e, data) ->
        submitButton.prop 'disabled', false

        progressBar.
          css("background", "red").
          text("Failed")


    fileInput.after barContainer
