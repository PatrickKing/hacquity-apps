

scrollPosition = null

$(document).on 'turbolinks:load', ->

  # Save the current scroll position so that it may be restored on next page load. This will deliver an approximation of a single page app like experience. We only need to use this on the numerous inline form elements, forms for creating entire new elements shouldn't receive the preserve-scroll-position class and be allowed to reset the scroll position as in normal navigation.

  if scrollPosition
    window.scrollTo.apply window, scrollPosition
    scrollPosition = null

  # Turbolinks replaces the body element, so we need to add this per page load
  $('body').on 'click', '.preserve-scroll-position', ->
    scrollPosition = [window.scrollX, window.scrollY]


  # We're taking advantage of a Rails / Turbolinks feature here: if you submit a form via AJAX and use redirect_to in the action, the Rails response will cause Turbolinks to handle the page load rather than refeshing as an ordinary form would.
  # This event handler causes *every* form in the application to be submitted by AJAX.
  # TODO: Not totally sure it will handle all form types correctly.
  # $('body').on "submit", "form", (event) ->
  #   return if $(this).attr('data-local')?

  #   event.preventDefault()

  #   method = $(this).children('input[name="_method"]').attr('value') or $(this).attr('method')

  #   $.ajax
  #     url: $(this).attr('action')
  #     method: method
  #     data: $(this).serialize()


