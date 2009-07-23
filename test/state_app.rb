# Test that the app state is correctly reported.
# Expected results: minimized app state is correctly reported.

require 'tea'

puts <<TEST
Minimise and restore the screen window.  The visibility of the window will be
reported below...
TEST

Tea.init
Tea::Screen.set_mode 320, 240
loop do
  puts "Tea::App.visible? == #{Tea::App.visible?}"
  begin
    e = Tea::Event.get(true)
    exit if e.class == Tea::App::Exit
  end until e.class == Tea::App::Minimized or e.class == Tea::App::Restored
end
