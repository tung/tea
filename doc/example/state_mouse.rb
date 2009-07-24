# Test that the mouse status is correctly reported.
# Expected results include the mouse x, y, left, middle and right button down
# status, printed whenever the mouse is used in the 400x300 screen window.

require 'tea'

puts <<TEST
Move the mouse in the window.  Mouse x, y, and left/middle/right button down
status should be reported here.
TEST

##############################################################################
# Swiped from event_mouse.rb.  I'd make a module, but I don't want to clutter
# this demo directory.

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
have_mouse = true
loop do
  begin
    e = Tea::Event.get(true)
    exit if e.class == Tea::App::Exit
  end until [Tea::Mouse::Move,
             Tea::Mouse::Down,
             Tea::Mouse::Up,
             Tea::Mouse::Gained,
             Tea::Mouse::Lost].include?(e.class)

  case e
  when Tea::Mouse::Gained then have_mouse = true
  when Tea::Mouse::Lost   then have_mouse = false
  end

  if have_mouse
    pr "Mouse (#{Tea::Mouse.x}, #{Tea::Mouse.y}), [#{Tea::Mouse.left?}|#{Tea::Mouse.middle?}|#{Tea::Mouse.right?}]"
  else
    pr "Mouse is out of the house"
  end
end
