# Test that the app state is correctly reported.
# Expected results: minimized app state, keybord and mouse focus is correctly
# reported.

require 'tea'

puts <<TEST
Try...

 * minimising/restoring the window
 * moving the mouse in/out of the window
 * changing focus in/out of the window

The app visibility, mouse and keyboard focus will be reported below.
TEST

Tea.init
Tea::Screen.set_mode 320, 240
e = nil
puts '%19s %20s%20s%20s' % ['EVENT', 'APP VISIBILITY', 'KEYBOARD', 'MOUSE']
puts '-' * 80
loop do
  visible = Tea::App.visible?  ? 'visible'     : 'not visible'
  kbd     = Tea::Kbd.in_app?   ? 'keyboard in' : 'keyboard not in'
  mouse   = Tea::Mouse.in_app? ? 'mouse in'    : 'mouse not in'
  puts '%19s:%20s%20s%20s' % [e.class, visible, kbd, mouse]
  begin
    e = Tea::Event.get(true)
    exit if e.class == Tea::App::Exit
  end until [Tea::App::Minimized, Tea::App::Restored,
             Tea::Kbd::Lost,      Tea::Kbd::Gained,
             Tea::Mouse::Lost,    Tea::Mouse::Gained].include?(e.class)
end
