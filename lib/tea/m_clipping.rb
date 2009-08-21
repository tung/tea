# This file holds the Clipping mixin.

require 'sdl'

#
module Tea

  # The Clipping mixin enables anything with an SDL-like buffer can get, set
  # and use a clipping rectangle to restrict where drawing takes place.
  #
  # To use the Clipping mixin, include it, and provide a clipping_buffer method
  # that returns the buffer to be clipped.
  #
  #   include Tea::Clipping
  #   def clipping_buffer
  #     @sdl_buffer
  #   end
  module Clipping

    # Get, set or run a block with a clipping rectangle that restricts where
    # drawing can take place.
    #
    # Getting the current clipping rectangle:
    #
    #   x, y, width, height = clippable_object.clip
    #
    # Setting a new clipping rectangle:
    #
    #   old_x, old_y, old_w, old_h = clippable_object.clip(new_x, new_y, new_w, new_h)
    #
    # Running a block with a clipping rectangle temporarily set:
    #
    #   clippable_object.clip(clip_x, clip_y, clip_w, clip_h) do
    #     # Draw onto clippable_object within clip rect here.
    #   end
    #
    def clip(x=nil, y=nil, w=nil, h=nil)
      buffer = clipping_buffer

      # rubysdl's SDL::Surface#get_clip_rect doesn't return anything useful.
      # Seems to be a bug, or at least compilation quirk.
      @clipping_rect = [0, 0, buffer.w, buffer.h] unless @clipping_rect
      old_clipping_rect = @clipping_rect

      case
      when !(x || y || w || h)                  # Get clip rect.
        # Do nothing.
      when x && y && w && h && !block_given?    # Set clip rect.
        @clipping_rect = [x, y, w, h]
        buffer.set_clip_rect *@clipping_rect
      when x && y && w && h &&  block_given?    # Run block with clip rect.
        @clipping_rect = [x, y, w, h]
        buffer.set_clip_rect *@clipping_rect
        begin
          yield
        ensure
          @clipping_rect = old_clipping_rect
          buffer.set_clip_rect *old_clipping_rect
        end
      else
        arg_count = 0
        [x, y, w, h].each { |arg| arg_count += 1 if arg == nil }
        raise ArgumentError, "wrong number of arguments (#{arg_count} for 0 or 4)", caller
      end

      old_clipping_rect
    end

  end

end
