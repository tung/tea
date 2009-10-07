# This tests that fonts can be loaded, rendered and drawn.
# Expected result: 'hello' in a small window for 5 seconds.

require 'tea'

puts <<TEST
You should see 'hello' in a small window for 5 seconds.
TEST

Tea.init
Tea::Screen.set_mode 320, 240

font = Tea::Font.new('font.bmp', Tea::Font::BITMAP_FONT, :transparent_color => Tea::Color::MAGENTA)
message = 'hello'

x = (Tea::Screen.w - font.string_w(message)) / 2
y = (Tea::Screen.h - font.h) / 2
font.draw_to Tea::Screen, x, y, message

Tea::Screen.update

sleep 5
