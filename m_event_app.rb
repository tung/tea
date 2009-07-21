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

  module Mouse
    # Event generated when mouse focus is gained.
    class Gained; end

    # Event generated when mouse focus is lost.
    class Lost; end
  end

  module Kbd
    # Event generated when keyboard input focus is gained.
    class Gained; end

    # Event generated when keyboard input focus is lost.
    class Lost; end
  end

  module App
    # Event generated when the player acts to close the screen window.
    class Exit; end

    # Event generated when the screen window is minimised.
    class Minimized; end

    # Event generated when the screen window is restored from being minimised.
    class Restored; end
  end

  module Event

    # Translates an app-related SDL::Event into an array of Tea::Event
    # objects.  For internal use only.
    def Event.translate_app_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::Quit
        out_events.push App::Exit.new

      when SDL::Event::Active
        if (sdl_event.state & SDL::Event::APPACTIVE) != 0
          out_events.push sdl_event.gain ? App::Restored.new : App::Minimized.new
        end
        if (sdl_event.state & SDL::Event::APPINPUTFOCUS) != 0
          out_events.push sdl_event.gain ? Kbd::Gained.new : Kbd::Lost.new
        end
        if (sdl_event.state & SDL::Event::APPMOUSEFOCUS) != 0
          out_events.push sdl_event.gain ? Mouse::Gained.new : Mouse::Lost.new
        end
      end

      out_events
    end
    private_class_method :translate_app_event

  end

end
