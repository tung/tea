# This file holds the mouse motion and button events.

require 'sdl'

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
        when Event::BUTTON_WHEELDOWN_ then @delta = 1
        when Event::BUTTON_WHEELUP_   then @delta = -1
        else
          raise Tea::Error, "Tea::Mouse::Scroll given an unexpected event: #{sdl_event.inspect}", caller
        end
      end
    end

    # Defaults for Mouse.x, Mouse.y, Mouse.left?, Mouse.middle?, Mouse.right?
    # and Mouse.in_app?
    @x = 0
    @y = 0
    @left = false
    @middle = false
    @right = false
    @in_app = false

    # Report the x position of the mouse in the screen window.  Updated when
    # Event.get is called.
    def Mouse.x
      @x
    end

    # Report the y position of the mouse in the screen window.  Updated when
    # Event.get is called.
    def Mouse.y
      @y
    end

    # Returns true if the left mouse button is down.  Updated when Event.get is
    # called.
    def Mouse.left?
      @left
    end

    # Returns true if the middle mouse button is down.  Updated when Event.get
    # is called.
    def Mouse.middle?
      @middle
    end

    # Returns true if the right mouse button is down.  Updated when Event.get
    # is called.
    def Mouse.right?
      @right
    end

    # Returns true if the mouse is in the screen window
    def Mouse.in_app?
      @in_app
    end

    # Update the mouse state, so that Mouse.x, Mouse.y, Mouse.left?,
    # Mouse.middle? and Mouse.right? return recent data.
    def Mouse.update_state(tea_event)
      case tea_event
      when Move
        @x = tea_event.x
        @y = tea_event.y
      when Down
        case tea_event.button
        when LEFT   then @left = true
        when MIDDLE then @middle = true
        when RIGHT  then @right = true
        end
      when Up
        case tea_event.button
        when LEFT   then @left = false
        when MIDDLE then @middle = false
        when RIGHT  then @right = false
        end
      when Lost
        @in_app = false
      when Gained
        @in_app = true
      end
    end
  end

  module Event

    # Missing mouse wheel button constants from rubysdl.  For internal use only.
    BUTTON_WHEELUP_ = 4
    BUTTON_WHEELDOWN_ = 5

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
        when BUTTON_WHEELDOWN_, BUTTON_WHEELUP_
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
