# This file holds the mouse motion and button events.

require 'sdl'

# Hot-patch for Ruby/SDL for missing mouse wheel constants.
module SDL
  module Mouse
    BUTTON_WHEELUP = 4
    BUTTON_WHEELDOWN = 5
  end
end

#
module Tea

  module Event

    # Event generated when the mouse cursor is moved.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +buttons+::   an array that may contain +:left+, +:middle+ and +:right+
    class MouseMove
      attr_reader :x, :y, :buttons
      def initialize(x, y, buttons)
        @x, @y = x, y
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
        @x, @y = x, y
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
        @x, @y = x, y
        @button = button
      end
    end

    # Event generated when the mouse wheel is scrolled down.
    #
    # +x+, +y+::    coordinates of the mouse cursor.
    class MouseScrollDown
      attr_reader :x, :y
      def initialize(x, y)
        @x, @y = x, y
      end
    end

    # Event generated when the mouse wheel is scrolled up.
    #
    # +x+, +y+::    coordinates of the mouse cursor.
    class MouseScrollUp
      attr_reader :x, :y
      def initialize(x, y)
        @x, @y = x, y
      end
    end

    # Convert a mouse-related SDL::Event into a Tea event.  For internal use only.
    def Event.translate_mouse_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::MouseMotion
        buttons = {}
        buttons[:left]   = (sdl_event.state & SDL::Mouse::BUTTON_LMASK) != 0
        buttons[:middle] = (sdl_event.state & SDL::Mouse::BUTTON_MMASK) != 0
        buttons[:right]  = (sdl_event.state & SDL::Mouse::BUTTON_RMASK) != 0
        out_events.push MouseMove.new(sdl_event.x, sdl_event.y, buttons)
      when SDL::Event::MouseButtonDown
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT, SDL::Mouse::BUTTON_MIDDLE, SDL::Mouse::BUTTON_RIGHT
          out_events.push MouseDown.new(sdl_event.x, sdl_event.y,
                                        (case sdl_event.button
                                         when SDL::Mouse::BUTTON_LEFT   then :left
                                         when SDL::Mouse::BUTTON_MIDDLE then :middle
                                         when SDL::Mouse::BUTTON_RIGHT  then :right
                                         end))
        when SDL::Mouse::BUTTON_WHEELDOWN
          out_events.push MouseScrollDown.new(sdl_event.x, sdl_event.y)
        when SDL::Mouse::BUTTON_WHEELUP
          out_events.push MouseScrollUp.new(sdl_event.x, sdl_event.y)
        end
      when SDL::Event::MouseButtonUp
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT, SDL::Mouse::BUTTON_MIDDLE, SDL::Mouse::BUTTON_RIGHT
          out_events.push MouseUp.new(sdl_event.x, sdl_event.y,
                                      (case sdl_event.button
                                       when SDL::Mouse::BUTTON_LEFT   then :left
                                       when SDL::Mouse::BUTTON_MIDDLE then :middle
                                       when SDL::Mouse::BUTTON_RIGHT  then :right
                                       end))
        end
      end

      out_events
    end
    private_class_method :translate_mouse_event

  end

end
