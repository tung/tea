# Test if an image can be loaded and drawn to the screen.
# Expected result is a 320x240 display with a smile in the middle for 2
# seconds.

require 'sprout'

Sprout.init
Sprout.screen_mode 320, 240

image = Sprout::Bitmap.new('smile.png')
x = (Sprout.screen.w - image.w) / 2
y = (Sprout.screen.h - image.h) / 2

Sprout.screen.draw image, x, y
Sprout.screen.flip

sleep 2
