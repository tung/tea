# This file holds the core Event module.

require 'sdl'

require 'c_error'
require 'm_event_app'

#
module Spot

  # The Event module allows access to the event queue, and the classes of
  # events that come out.  Event handling is the heart and soul of most games,
  # so this module is quite important.
  module Event

    # Get the next event in the event queue.  If wait is true and there are no
    # events to return, this method will wait until there is one and return it.
    # Otherwise, an empty event queue will return nil.
    #
    # May raise Spot::Error if getting an event fails.
    def Event.get(wait=false)
      begin
        event = if wait
                  SDL::Event.wait
                else
                  SDL::Event.poll
                end
        case event
        when SDL::Event::Active, SDL::Event::Quit
          Event.translate_app_event event
        end
      rescue SDL::Error => e
        raise Spot::Error, e.message, e.backtrace
      end
    end

  end

end
