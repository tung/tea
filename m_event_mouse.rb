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

  module Mouse

    # Mouse button constants for mouse events.
    LEFT = :LEFT
    MIDDLE = :MIDDLE
    RIGHT = :RIGHT

    # Event generated when the mouse cursor is moved.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +buttons+::   an array that may contain +:left+, +:middle+ and +:right+
    class Move
      attr_reader :x, :y, :buttons
      def initialize(sdl_event)
        @x = sdl_event.x
        @y = sdl_event.y
        @buttons = {}
        @buttons[Mouse::LEFT]   = (sdl_event.state & SDL::Mouse::BUTTON_LMASK) != 0
        @buttons[Mouse::MIDDLE] = (sdl_event.state & SDL::Mouse::BUTTON_MMASK) != 0
        @buttons[Mouse::RIGHT]  = (sdl_event.state & SDL::Mouse::BUTTON_RMASK) != 0
      end
    end

    # Event generated when a mouse button is held down.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +button+::    the mouse button that is down: +:left+, +:middle+ or +:right+
    class Down
      attr_reader :x, :y, :button
      def initialize(sdl_event)
        @x = sdl_event.x
        @y = sdl_event.y
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT   then @button = Mouse::LEFT
        when SDL::Mouse::BUTTON_MIDDLE then @button = Mouse::MIDDLE
        when SDL::Mouse::BUTTON_RIGHT  then @button = Mouse::RIGHT
        end
      end
    end

    # Event generated when a mouse button that was held down is released.
    #
    # +x+, +y+::    coordinates of the mouse cursor
    # +button+::    the mouse button that was released: +:left+, +:middle+ or
    #               +:right+
    class Up
      attr_reader :x, :y, :button
      def initialize(sdl_event)
        @x = sdl_event.x
        @y = sdl_event.y
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT   then @button = Mouse::LEFT
        when SDL::Mouse::BUTTON_MIDDLE then @button = Mouse::MIDDLE
        when SDL::Mouse::BUTTON_RIGHT  then @button = Mouse::RIGHT
        end
      end
    end

    # Event generated when the mouse wheel is scrolled.
    #
    # +x+, +y+::    coordinates of the mouse cursor.
    # +delta+::     1 when scrolling down, -1 when scrolling up.
    class Scroll
      attr_reader :x, :y, :delta
      def initialize(sdl_event)
        @x = sdl_event.x
        @y = sdl_event.y
        case sdl_event.button
        when SDL::Mouse::BUTTON_WHEELDOWN then @delta = 1
        when SDL::Mouse::BUTTON_WHEELUP   then @delta = -1
        else
          raise Tea::Error, "Tea::Mouse::Scroll given an unexpected event: #{sdl_event.inspect}", caller
        end
      end
    end
  end

  module Event

    # Convert a mouse-related SDL::Event into a Tea event.  For internal use only.
    def Event.translate_mouse_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::MouseMotion
        out_events.push Mouse::Move.new(sdl_event)
      when SDL::Event::MouseButtonDown
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT, SDL::Mouse::BUTTON_MIDDLE, SDL::Mouse::BUTTON_RIGHT
          out_events.push Mouse::Down.new(sdl_event)
        when SDL::Mouse::BUTTON_WHEELDOWN, SDL::Mouse::BUTTON_WHEELUP
          out_events.push Mouse::Scroll.new(sdl_event)
        end
      when SDL::Event::MouseButtonUp
        # Ignore MouseButtonUp for the scroll wheel.
        case sdl_event.button
        when SDL::Mouse::BUTTON_LEFT, SDL::Mouse::BUTTON_MIDDLE, SDL::Mouse::BUTTON_RIGHT
          out_events.push Mouse::Up.new(sdl_event)
        end
      end

      out_events
    end
    private_class_method :translate_mouse_event

  end

end
