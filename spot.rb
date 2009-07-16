# Spot is a simple 2D game development framework for Ruby.

require 'sdl'

require 'c_bitmap'
require 'c_error'
require 'm_event'
require 'screen'

# The Spot module acts as a namespace for all Spot-related objects and
# methods.
module Spot

  # Initialise Spot.  This needs to be called before using any of Spot's
  # objects or methods.
  #
  # May throw Spot::Error if initialisation fails.
  def Spot.init
    begin
      SDL.init(SDL::INIT_VIDEO)
    rescue SDL::Error => e
      raise Spot::Error, e.message, e.backtrace
    end
  end

end
