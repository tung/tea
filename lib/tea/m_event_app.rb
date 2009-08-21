# This file holds app-related event handling.

require 'sdl'

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

    # Default for App.visible?.
    @visible = true

    # Returns true if the screen window has not been minimised, otherwise
    # false.
    def App.visible?
      @visible
    end

    # Update the reported app state when a Tea event is retrieved, so
    # App.visible? returns the right status.  Called automatically by
    # Event.get.
    def App.update_state(tea_event)
      case tea_event
      when Minimized then @visible = false
      when Restored  then @visible = true
      end
      @visible
    end
  end

  module Event

    # APP constants rubysdl is missing.  For internal use only.
    APPMOUSEFOCUS_ = 0x01
    APPINPUTFOCUS_ = 0x02
    APPACTIVE_     = 0x04

    # Translates an app-related SDL::Event into an array of Tea::Event
    # objects.  For internal use only.
    def Event.translate_app_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::Quit
        out_events.push App::Exit.new

      when SDL::Event::Active
        if (sdl_event.state & APPACTIVE_) != 0
          out_events.push sdl_event.gain ? App::Restored.new : App::Minimized.new
        end
        if (sdl_event.state & APPINPUTFOCUS_) != 0
          out_events.push sdl_event.gain ? Kbd::Gained.new : Kbd::Lost.new
        end
        if (sdl_event.state & APPMOUSEFOCUS_) != 0
          out_events.push sdl_event.gain ? Mouse::Gained.new : Mouse::Lost.new
        end
      end

      out_events
    end
    private_class_method :translate_app_event

  end

end
