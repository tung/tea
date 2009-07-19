# This file holds app-related event handling.

require 'sdl'

# A hot-patch to Ruby/SDL for missing SDL::Event::Active#state constants.
module SDL
  class Event
    APPMOUSEFOCUS = 0x01
    APPINPUTFOCUS = 0x02
    APPACTIVE     = 0x04
  end
end

#
module Tea

  module Event

    # Event generated when the player acts to close the screen window.
    class Exit; end

    # Event generated when the screen window is minimised.
    class Minimized; end

    # Event generated when the screen window is restored from being minimised.
    class Restored; end

    # Event generated when keyboard input focus is gained.
    class KeyboardGained; end

    # Event generated when keyboard input focus is lost.
    class KeyboardLost; end

    # Event generated when mouse focus is gained.
    class MouseGained; end

    # Event generated when mouse focus is lost.
    class MouseLost; end

    # Translates an app-related SDL::Event into an array of Tea::Event
    # objects.  For internal use only.
    def Event.translate_app_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::Quit
        out_events.push Exit.new

      when SDL::Event::Active
        if (sdl_event.state & SDL::Event::APPACTIVE) != 0
          out_events.push sdl_event.gain ? Restored.new : Minimized.new
        end
        if (sdl_event.state & SDL::Event::APPINPUTFOCUS) != 0
          out_events.push sdl_event.gain ? KeyboardGained.new : KeyboardLost.new
        end
        if (sdl_event.state & SDL::Event::APPMOUSEFOCUS) != 0
          out_events.push sdl_event.gain ? MouseGained.new : MouseLost.new
        end
      end

      out_events
    end

  end

end
