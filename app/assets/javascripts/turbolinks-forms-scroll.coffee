

scrollPosition = null

$(document).on 'turbolinks:load', ->

  # Save the current scroll position so that it may be restored on next page load. This will deliver an approximation of a single page app like experience. We only need to use this on the numerous inline form elements, forms for creating entire new elements shouldn't receive the preserve-scroll-position class and be allowed to reset the scroll position as in normal navigation.

  if scrollPosition
    window.scrollTo.apply window, scrollPosition
    scrollPosition = null

  # Turbolinks replaces the body element, so we need to add this per page load
  $('body').on 'click', '.preserve-scroll-position', ->
    scrollPosition = [window.scrollX, window.scrollY]

