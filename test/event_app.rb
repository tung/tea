# Test that app events are being picked up.
# This test is interactive, and should display messages for:
#
#  * Gaining and losing mouse focus
#  * Gaining and losing keyboard focus
#  * Minimising and restoring the screen window
#  * App exit

require 'spot'

puts <<TEST
This is an interactive event test.  It should display messages for:

  * Gaining and losing mouse focus
  * Gaining and losing keyboard focus
  * Minimising and restoring the screen window
  * App exit

Go ahead and start doing things like changing focus.

TEST

Spot.init
Spot::Screen.set_mode 320, 240

loop do
  case (e = Spot::Event.get)
  when Spot::Event::MouseGained
    puts 'MouseGained event received'
  when Spot::Event::MouseLost
    puts 'MouseLost event received'
  when Spot::Event::KeyboardGained
    puts 'KeyboardGained event received'
  when Spot::Event::KeyboardLost
    puts 'KeyboardLost event received'
  when Spot::Event::Restored
    puts 'Restored event received'
  when Spot::Event::Minimized
    puts 'Minimized event received'
  when Spot::Event::Exit
    puts 'Exit event received'
    exit
  end
  sleep 0.01
end
