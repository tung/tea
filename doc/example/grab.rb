# Test that grabbing from bitmaps works.
# Expected results are a smiley on the screen, but with its quarters swapped.

require 'tea'

puts <<TEST
You should see a smiley in the centre of the screen for 5 seconds, but with its
quarters swapped.
TEST

Tea.init
Tea::Screen.set_mode 320, 240

smiley = Tea::Bitmap.new("smile.png")
sw2 = smiley.w / 2
sh2 = smiley.h / 2
top_left     = smiley.grab(  0,   0, sw2, sh2)
top_right    = smiley.grab(sw2,   0, sw2, sh2)
bottom_left  = smiley.grab(  0, sh2, sw2, sh2)
bottom_right = smiley.grab(sw2, sh2, sw2, sh2)

Tea::Screen.blit bottom_right, Tea::Screen.w / 2 - sw2, Tea::Screen.h / 2 - sh2
Tea::Screen.blit bottom_left,        Tea::Screen.w / 2, Tea::Screen.h / 2 - sh2
Tea::Screen.blit top_right,    Tea::Screen.w / 2 - sw2,       Tea::Screen.h / 2
Tea::Screen.blit top_left,           Tea::Screen.w / 2,       Tea::Screen.h / 2
Tea::Screen.update

sleep 5
