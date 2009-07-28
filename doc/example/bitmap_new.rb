# Test that Bitmaps can be created without an image file.
# Expected results are a red square inside a cyan square.

require 'tea'

puts <<TEST
You should see a red square in a cyan square for 2 seconds.
TEST

Tea.init
a = Tea::Bitmap.new(200, 200, 0x00ffffff)
Tea::Screen.set_mode 400, 300
b = Tea::Bitmap.new(150, 150, 0xff0000ff)

Tea::Screen.blit a, 100, 50
Tea::Screen.blit b, 125, 75
Tea::Screen.update

sleep 2
