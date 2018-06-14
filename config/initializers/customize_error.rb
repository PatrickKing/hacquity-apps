# The field_with_errors div which is inserted around fields that fail validation will destroy the mui styling on the form elements, since it depends on directly wrapping each form element with a div bearing a css class.
# We pass the HTML straight through without wrapping it, if there are errors.

ActionView::Base.field_error_proc = proc { |html_tag, instance|
  STDERR.puts html_tag, html_tag.class
  html_tag
}