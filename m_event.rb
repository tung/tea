# This file holds the core Event module.

require 'sdl'

require 'c_error'
require 'm_event_app'
require 'm_event_mouse'

#
module Spot

  # The Event module allows access to the event queue, and the classes of
  # events that come out.  Event handling is the heart and soul of most games,
  # so this module is quite important.
  module Event

    # Spot's generated event queue.  Add to the back, get from the front.
    @@event_queue = []

    # Get the next event in the event queue.  If wait is true and there are no
    # events to return, this method will wait until there is one and return it.
    # Otherwise, an empty event queue will return nil.
    #
    # May raise Spot::Error if getting an event fails.
    def Event.get(wait=false)
      return @@event_queue.shift if @@event_queue.length > 0

      begin
        sdl_event = if wait then SDL::Event.wait else SDL::Event.poll end

        if [SDL::Event::Active,
            SDL::Event::Quit].include?(sdl_event.class)
          @@event_queue.push(*Event.translate_app_event(sdl_event))
        elsif [SDL::Event::MouseMotion,
               SDL::Event::MouseButtonDown,
               SDL::Event::MouseButtonUp].include?(sdl_event.class)
          @@event_queue.push(*Event.translate_mouse_event(sdl_event))
        end

        @@event_queue.shift
      rescue SDL::Error => e
        raise Spot::Error, e.message, e.backtrace
      end
    end

  end

end
