# Test if an image can be loaded and drawn to the screen.
# Expected result is a 320x240 display with a smile in the middle for 2
# seconds.

require 'tea'

puts <<TEST
You should see a 320x240 window with a smile in the centre.
TEST

Tea.init
Tea::Screen.set_mode 320, 240

image = Tea::Bitmap.new('smile.png')
x = (Tea::Screen.w - image.w) / 2
y = (Tea::Screen.h - image.h) / 2

Tea::Screen.blit image, x, y
Tea::Screen.update

sleep 2
