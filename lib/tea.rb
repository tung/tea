# Tea is a simple 2D game development library for Ruby.

require 'sdl'

require 'tea/c_bitmap'
require 'tea/c_error'
require 'tea/m_event'
require 'tea/screen'

# The Tea module acts as a namespace for all Tea-related objects and
# methods.
module Tea

  # Initialise Tea.  This needs to be called before using any of Tea's
  # objects or methods.
  #
  # May throw Tea::Error if initialisation fails.
  def Tea.init
    begin
      SDL.init(SDL::INIT_VIDEO)

      # Get typed characters from keys when pressed.
      SDL::Event.enable_unicode
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end
  end

end
