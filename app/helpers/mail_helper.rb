module MailHelper

  def slate_colour
    '#546E7A'
  end

  def purple_colour
    '#5E35B1'
  end

  def background_colour
    "background-color: #{slate_colour};"
  end

  def admin_background_colour
    "background-color: #{purple_colour};"
  end

  def td_style
    'width: 15px; padding: 0;'
  end

  def font_family
    'font-family: Arial, Verdana, Tahoma;'
  end

  def host_url
    options = Rails.configuration.action_mailer.default_url_options

    options[:protocol] == 'https' ? builder = URI::HTTPS : builder = URI::HTTP

    builder.build(options).to_s
  end

end