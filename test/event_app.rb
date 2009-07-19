# Test that app events are being picked up.
# This test is interactive, and should display messages for:
#
#  * Gaining and losing mouse focus
#  * Gaining and losing keyboard focus
#  * Minimising and restoring the screen window
#  * App exit

require 'tea'

puts <<TEST
This is an interactive event test.  It should display messages for:

  * Gaining and losing mouse focus
  * Gaining and losing keyboard focus
  * Minimising and restoring the screen window
  * App exit

Go ahead and start doing things like changing focus.

TEST

Tea.init
Tea::Screen.set_mode 320, 240

loop do
  case (e = Tea::Event.get)
  when Tea::Event::MouseGained
    puts 'MouseGained event received'
  when Tea::Event::MouseLost
    puts 'MouseLost event received'
  when Tea::Event::KeyboardGained
    puts 'KeyboardGained event received'
  when Tea::Event::KeyboardLost
    puts 'KeyboardLost event received'
  when Tea::Event::Restored
    puts 'Restored event received'
  when Tea::Event::Minimized
    puts 'Minimized event received'
  when Tea::Event::Exit
    puts 'Exit event received'
    exit
  end
  sleep 0.01
end
