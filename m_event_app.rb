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
module Spot

  module Event

    # The event class for the exit event.
    class Exit; end

    # Event generated when the screen window is minimised.
    class Minimized; end

    # Event generated when the screen window is restored from being minimised.
    class Restored; end

    # Translates an app-related SDL::Event into a Spot::Event or an array of
    # Spot::Event objects.  For internal use only.
    def Event.translate_app_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::Quit
        out_events.push Exit.new
      when SDL::Event::Active
        if (sdl_event.state & SDL::Event::APPACTIVE) != 0
          if sdl_event.gain
            out_events.push Restored.new
          else
            out_events.push Minimized.new
          end
        end
      end

      out_events
    end

  end

end