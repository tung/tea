# This file holds the core Event module.

require 'sdl'

require 'c_error'
require 'm_event_app'
require 'm_event_keyboard'
require 'm_event_mouse'

#
module Tea

  # The Event module allows access to the event queue, and the classes of
  # events that come out.  Event handling is the heart and soul of most games,
  # so this module is quite important.
  module Event

    # Tea's generated event queue.  Add to the back, get from the front.
    @@event_queue = []

    # Get the next event in the event queue.  If wait is true and there are no
    # events to return, this method will wait until there is one and return it.
    # Otherwise, an empty event queue will return nil.
    #
    # May raise Tea::Error if getting an event fails.
    def Event.get(wait=false)
      return @@event_queue.shift if @@event_queue.length > 0

      begin
        if wait
          begin
            sdl_event = SDL::Event.wait
            if (out_events = Event.translate_event(sdl_event))
              @@event_queue.push *out_events
            end
          end until @@event_queue.length > 0
        else
          if (out_events = Event.translate_event(SDL::Event.poll))
            @@event_queue.push *out_events
          end
        end

        @@event_queue.shift
      rescue SDL::Error => e
        raise Tea::Error, e.message, e.backtrace
      end
    end

    # Convert an SDL::Event into one or more Tea events.  May return nil, a
    # single event object or multiple events in an array.
    def Event.translate_event(sdl_event)
      case sdl_event
      when SDL::Event::Active, SDL::Event::Quit
        Event.translate_app_event sdl_event
      when SDL::Event::MouseMotion, SDL::Event::MouseButtonDown, SDL::Event::MouseButtonUp
        Event.translate_mouse_event sdl_event
      when SDL::Event::KeyDown, SDL::Event::KeyUp
        Event.translate_keyboard_event sdl_event
      end
    end

  end

end
