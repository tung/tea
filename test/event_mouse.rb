# Test that mouse events are being picked up.
# Expected output is reporting of mouse move/down/up events, with position and
# relevant buttons.

require 'spot'

puts <<TEST
Move the mouse in the window.  Mouse move/down/up events should be reported,
with position and relevant buttons.
TEST

Spot.init
Spot::Screen.set_mode 400, 300

$windows = RUBY_PLATFORM =~ /w(?:in)?32/
SAVE_POSITION = "\x1b[s"
RESTORE_POSITION = "\x1b[u"
HIDE_CURSOR = "\x1b[?25l"
UNHIDE_CURSOR = "\x1b[?25h"
CLEAR_TO_LINE_END = "\x1b[K"

def pr(*args)
  print HIDE_CURSOR, SAVE_POSITION if !$windows
  print *args
  print CLEAR_TO_LINE_END, RESTORE_POSITION, UNHIDE_CURSOR if !$windows
end

last_event_class = nil

while e = Spot::Event.get(true) do
  if e.class == Spot::Event::Exit
    puts
    exit
  end

  if [Spot::Event::MouseMove, Spot::Event::MouseDown, Spot::Event::MouseUp].include?(e.class) && e.class != last_event_class
    puts
    last_event_class = e.class
  end

  case e
  when Spot::Event::MouseMove
    pr "mouse move: x = #{e.x}, y = #{e.y}, buttons = #{e.buttons.join(',')}"
  when Spot::Event::MouseDown
    pr "mouse down: x = #{e.x}, y = #{e.y}, button = #{e.button}"
  when Spot::Event::MouseUp
    pr "mouse up  : x = #{e.x}, y = #{e.y}, button = #{e.button}"
  end
end
