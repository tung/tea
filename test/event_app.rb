# Test that app events are being picked up.
# This test is interactive, and should display messages for:
#
#  * Gaining and losing mouse focus
#  * Gaining and losing keyboard focus
#  * Gaining and losing app focus
#  * App exit

require 'spot'

puts <<TEST
This is an interactive event test.  It should display messages for:

  * Gaining and losing mouse focus
  * Gaining and losing keyboard focus
  * Gaining and losing app focus
  * App exit

Go ahead and start doing things like changing focus.

TEST

Spot.init
Spot::Screen.set_mode 320, 240

loop do
  case (e = Spot::Event.get)
=begin
  when Spot::Event::MouseFocus
    if e.focus_gained?
      puts 'MouseFocus gained'
    else
      puts 'MouseFocus lost'
    end
  when Spot::Event::KeyboardFocus
    if e.focus_gained?
      puts 'KeyboardFocus lost'
    else
      puts 'KeyboardFocus gained'
    end
  when Spot::Event::AppFocus
    if e.focus_gained?
      puts 'AppFocus gained'
    else
      puts 'AppFocus lost'
    end
=end
  when Spot::Event::Exit
    puts 'Exit event received'
    exit
  end
  sleep 0.01
end
