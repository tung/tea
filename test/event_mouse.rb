# Test that mouse events are being picked up.
# Expected output is reporting of mouse move/down/up/scroll events, with
# position and relevant buttons.

require 'tea'

puts <<TEST
Move the mouse in the window.  Mouse move/down/up events should be reported,
with position and relevant buttons.  Mouse wheel scrolling should also be
picked up, with at least the cursor position.
TEST

##############################################################################

# We can avoid flooding the terminal with VT100 codes.  Sorry Windows.
$windows = RUBY_PLATFORM =~ /w(?:in)?32/
SAVE_POSITION = "\x1b[s"
RESTORE_POSITION = "\x1b[u"
HIDE_CURSOR = "\x1b[?25l"
UNHIDE_CURSOR = "\x1b[?25h"
CLEAR_TO_LINE_END = "\x1b[K"

# VT100-enhanced printing function that overwrites the current terminal line.
def pr(*args)
  print HIDE_CURSOR, SAVE_POSITION if !$windows
  print *args
  if $windows
    puts
  else
    print CLEAR_TO_LINE_END, RESTORE_POSITION, UNHIDE_CURSOR
  end
end

##############################################################################

Tea.init
Tea::Screen.set_mode 400, 300

# Event tracking to only put newlines when the event class changes.
mouse_events = [Tea::Mouse::Move,
                Tea::Mouse::Down,
                Tea::Mouse::Up,
                Tea::Mouse::Scroll]
handled = false
last_event_class = Tea::Mouse::Move

# Track repeated scrolling in the same direction.
scroll_pos = 0

loop do
  e = Tea::Event.get(true)

  if e.class == Tea::Event::Exit
    puts
    break
  end

  # Put a newline when the event class changes.
  if handled && mouse_events.include?(e.class) && e.class != last_event_class
    puts
    last_event_class = e.class
    scroll_pos = 0
  end

  handled = true
  case e
  when Tea::Mouse::Move
    buttons = (e.buttons.select { |button, down| down }).keys
    pr "mouse move : x = #{e.x}, y = #{e.y}, buttons = #{buttons.join(',')}"
  when Tea::Mouse::Down
    pr "mouse down : x = #{e.x}, y = #{e.y}, button = #{e.button}"
  when Tea::Mouse::Up
    pr "mouse up   : x = #{e.x}, y = #{e.y}, button = #{e.button}"
  when Tea::Mouse::Scroll
    dir = e.delta == 1 ? 'down' : 'up  '
    scroll_pos += e.delta
    pr "scroll #{dir}: x = #{e.x}, y = #{e.y}, position = #{scroll_pos} (#{e.delta})"
  else
    handled = false
  end
end
