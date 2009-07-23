# Test that the keyboard state is being picked up.
# Expected output is that all keyboard events will print if the 'A' key is
# being pressed, and if Num Lock is active.

require 'tea'

puts <<TEST
Press some keys.  Printed lines will tell if 'A' is being pressed,
and if Num Lock is active.
TEST

Tea.init
Tea::Screen.set_mode 320, 240
loop do
  a_down = Tea::Kbd.key_down?(Tea::Kbd::A) ? 'DOWN' : 'UP'
  num_lock_active = Tea::Kbd.mod_active?(Tea::Kbd::NUM_LOCK) ? 'ON' : 'OFF'
  puts "'A' is #{a_down}; Num Lock is #{num_lock_active}"
  begin
    e = Tea::Event.get(true)
    exit if e.class == Tea::App::Exit
  end until e.class == Tea::Kbd::Down || e.class == Tea::Kbd::Up
  print "(#{e.key}); "
end
