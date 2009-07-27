# This file contains the event dispatch mixin.

require 'tea/c_error'

#
module Tea

  module Event

    # The Dispatch mixin gives any object the ability to handle Tea events with
    # method calls.  To use it, include the mixin in your class
    #
    #   include Tea::Event::Dispatch
    #
    # define the handling methods (all optional)
    #
    #   def app_exit; end
    #   def app_restored; end
    #   def app_minimized; end
    #   def kbd_down; end
    #   def kbd_up; end
    #   def mouse_move; end
    #   def mouse_down; end
    #   def mouse_up; end
    #   def mouse_scroll; end
    #
    # and when you need events handled, call your instance's dispatch_event
    # method
    #
    #   handler = MyEventHandler.new
    #   ...
    #   loop do
    #     event = Tea::Event.get
    #     handler.dispatch_event event if event
    #     ...
    #   end
    #
    # Tea will then call the method matching the event received.
    module Dispatch

      def dispatch_event(tea_event)
        class_string = tea_event.class.to_s
        unless class_string =~ /^Tea::(?:App|Kbd|Mouse)::[A-Za-z]+$/
          raise Tea::Error, "Can't dispatch on class #{class_string}", caller
        end
        msg = class_string.split('::', 2)[1].sub('::', '_').downcase.intern
        send msg, tea_event if respond_to?(msg)
      end

    end

  end

end
