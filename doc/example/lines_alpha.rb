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

Tea::Screen.rect 200, 0, 200, 300, 0xff0000ff
20.times { |n| Tea::Screen.line 10,  10 + n, 390,  10 + n, 0x00ff0080 }
20.times { |n| Tea::Screen.line 10, 100 + n, 390, 100 + n, 0x0000ff80, :mix => :blend }
20.times { |n| Tea::Screen.line 10, 200 + n, 390, 200 + n, 0xffffff80, :mix => :replace }

Tea::Screen.update
sleep 5
