# Sprout is a simple 2D game development framework for Ruby.

require 'sdl'

require 'c_bitmap'
require 'c_error'
require 'c_screen'
require 'primitives'

# The Sprout module acts as a namespace for all Sprout-related objects and
# methods.
module Sprout

  # Initialise Sprout.  This needs to be called before using any of Sprout's
  # objects or methods.
  #
  # May throw Sprout::Error if initialisation fails.
  def Sprout.init
    begin
      SDL.init(SDL::INIT_VIDEO)
    rescue SDL::Error => e
      raise Sprout::Error, e.message, e.backtrace
    end
  end

  # Get the amount of time since Sprout was initialised in milliseconds.  Note
  # that this wraps around if the game runs for longer than 49 days.
  def Sprout.time
    SDL.get_ticks
  end

end
