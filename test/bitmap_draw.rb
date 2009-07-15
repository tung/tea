# Test if an image can be loaded and drawn to the screen.
# Expected result is a 320x240 display with a smile in the middle for 2
# seconds.

require 'spot'

puts <<TEST
You should see a 320x240 window with a smile in the centre.
TEST

Spot.init
Spot.screen_mode 320, 240

image = Spot::Bitmap.new('smile.png')
x = (Spot.screen.w - image.w) / 2
y = (Spot.screen.h - image.h) / 2

Spot.screen.blit image, x, y
Spot.screen.flip

sleep 2
