# This file holds app-related event handling.

require 'sdl'

#
module Spot

  module Event

    # The event class for the exit event.
    class Exit; end

    # Translates an app-related SDL::Event into a Spot::Event.  For internal
    # use only.
    def Event.translate_app_event(sdl_event)
      case sdl_event
      when SDL::Event::Quit
        Exit.new
      end
    end

  end

end
