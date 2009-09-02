# Tea is a simple 2D game development library for Ruby.

require 'sdl'

require 'tea/c_bitmap'
require 'tea/c_error'
require 'tea/c_sound'
require 'tea/m_event'
require 'tea/o_screen'

# The Tea module acts as a namespace for all Tea-related objects and
# methods.
module Tea

  # Initialise Tea.  This needs to be called before using any of Tea's
  # objects or methods.
  #
  # May throw Tea::Error if initialisation fails.
  def Tea.init
    SDL.init(SDL::INIT_VIDEO | SDL::INIT_AUDIO)

    # Get typed characters from keys when pressed.
    SDL::Event.enable_unicode
    SDL::Mixer.open 44100, SDL::Mixer::DEFAULT_FORMAT, SDL::Mixer::DEFAULT_CHANNELS, 1024
  rescue SDL::Error => e
    raise Tea::Error, e.message, e.backtrace
  end

end
