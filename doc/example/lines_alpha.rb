# Test that line alpha mixes properly.
# Expected results:
#
# * half-red background
# * green line, translucent
# * blue line, translucent
# * white line, solid

require 'tea'

puts <<TEST
You should see for 5 seconds:

 * half-red background
 * green line, translucent
 * blue line, translucent
 * white line, solid
TEST

Tea.init
Tea::Screen.set_mode 400, 300

tl_green = Tea::Color.mix(  0, 255,   0, 128)
tl_blue  = Tea::Color.mix(  0,   0, 255, 128)
tl_white = Tea::Color.mix(255, 255, 255, 128)

Tea::Screen.rect 200, 0, 200, 300, Tea::Color::RED
20.times { |n| Tea::Screen.line 10,  10 + n, 390,  10 + n, tl_green }
20.times { |n| Tea::Screen.line 10, 100 + n, 390, 100 + n, tl_blue, :mix => :blend }
20.times { |n| Tea::Screen.line 10, 200 + n, 390, 200 + n, tl_white, :mix => :replace }

Tea::Screen.update
sleep 5
