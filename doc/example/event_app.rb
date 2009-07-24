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
  when Tea::Mouse::Gained
    puts 'Mouse::Gained event received'
  when Tea::Mouse::Lost
    puts 'Mouse::Lost event received'
  when Tea::Kbd::Gained
    puts 'Kbd::Gained event received'
  when Tea::Kbd::Lost
    puts 'Kbd::Lost event received'
  when Tea::App::Restored
    puts 'App::Restored event received'
  when Tea::App::Minimized
    puts 'App::Minimized event received'
  when Tea::App::Exit
    puts 'App::Exit event received'
    exit
  end
  sleep 0.01
end
