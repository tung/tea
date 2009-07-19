# Tea is a simple 2D game development framework for Ruby.

require 'sdl'

require 'c_bitmap'
require 'c_error'
require 'm_event'
require 'screen'

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
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end
  end

end
