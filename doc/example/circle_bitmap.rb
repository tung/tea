# Test that a circle drawn to a bitmap is drawn correctly.
# Expected result is a filled white circle.

require 'tea'

puts <<TEST
You should see a filled white circle for 5 seconds.
TEST

Tea.init
Tea::Screen.set_mode 320, 240

b = Tea::Bitmap.new(320, 240, Tea::Color.mix(0, 0, 0, 0))
b.circle 160, 120, 100, Tea::Color::WHITE, :mix => :replace
Tea::Screen.blit b, 0, 0

Tea::Screen.update
sleep 5
