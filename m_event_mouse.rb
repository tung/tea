# This file holds the mouse motion and button events.

require 'sdl'

#
module Spot

  module Event

    # Event generated when the mouse cursor is moved.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +buttons+::   an array that may contain +:left+, +:middle+ and +:right+
    class MouseMove
      attr_reader :x, :y, :buttons
      def initialize(x, y, buttons)
        @x = x
        @y = y
        @buttons = buttons
      end
    end

    # Event generated when a mouse button is held down.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +button+::    the mouse button that is down: +:left+, +:middle+ or +:right+
    class MouseDown
      attr_reader :x, :y, :button
      def initialize(x, y, button)
        @x = x
        @y = y
        @button = button
      end
    end

    # Event generated when a mouse button that was held down is released.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +button+::    the mouse button that was released: +:left+, +:middle+ or
    #               +:right+
    class MouseUp
      attr_reader :x, :y, :button
      def initialize(x, y, button)
        @x = x
        @y = y
        @button = button
      end
    end

    # Convert an SDL::Event into one or more Spot events.
    def Event.translate_mouse_event(sdl_event)
      case sdl_event
      when SDL::Event::MouseMotion
        buttons = []
        buttons << :left   if (sdl_event.state & SDL::Mouse::BUTTON_LMASK) != 0
        buttons << :middle if (sdl_event.state & SDL::Mouse::BUTTON_MMASK) != 0
        buttons << :right  if (sdl_event.state & SDL::Mouse::BUTTON_RMASK) != 0
        buttons.compact!
        MouseMove.new(sdl_event.x, sdl_event.y, buttons)
      when SDL::Event::MouseButtonDown
        MouseDown.new(sdl_event.x, sdl_event.y,
                      (case sdl_event.button
                       when SDL::Mouse::BUTTON_LEFT   then :left
                       when SDL::Mouse::BUTTON_MIDDLE then :middle
                       when SDL::Mouse::BUTTON_RIGHT  then :right
                       end))
      when SDL::Event::MouseButtonUp
        MouseUp.new(sdl_event.x, sdl_event.y,
                    (case sdl_event.button
                     when SDL::Mouse::BUTTON_LEFT   then :left
                     when SDL::Mouse::BUTTON_MIDDLE then :middle
                     when SDL::Mouse::BUTTON_RIGHT  then :right
                     end))
      end
    end

  end

end
