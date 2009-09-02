# Test that alpha blending works for circles.
# Expected results: 8 green circles drawn over the edges of a white-bordered
# blue rectangle, varying in outline, anti-aliasing and blend/replace alpha
# mixing.

require 'tea'

puts <<TEST
You should see a white-bordered blue rectangle and circles along the edges:

--b     --r     -ab

-ar             o-b

o-r     oab     oar

o--   = outline
-a-   = antialias
--b/r = blend/replace

Press any key to exit.
TEST

Tea.init
Tea::Screen.set_mode 400, 300

Tea::Screen.rect 100, 75, 200, 150, Tea::Color::WHITE

b = Tea::Bitmap.new(Tea::Screen.w, Tea::Screen.h, Tea::Color.mix(0, 0, 0, 0))
b.rect 105, 80, 190, 140, Tea::Color.mix(0, 0, 255)

translucent_green = Tea::Color.mix(0, 255, 0, 128)
b.circle 100,  75, 25, translucent_green, :outline => false, :antialias => false, :mix => :blend
b.circle 200,  75, 25, translucent_green, :outline => false, :antialias => false, :mix => :replace
b.circle 300,  75, 25, translucent_green, :outline => false, :antialias => true,  :mix => :blend

b.circle 100, 150, 25, translucent_green, :outline => false, :antialias => true,  :mix => :replace
b.circle 300, 150, 25, translucent_green, :outline => true,  :antialias => false, :mix => :blend

b.circle 100, 225, 25, translucent_green, :outline => true,  :antialias => false, :mix => :replace
b.circle 200, 225, 25, translucent_green, :outline => true,  :antialias => true,  :mix => :blend
b.circle 300, 225, 25, translucent_green, :outline => true,  :antialias => true,  :mix => :replace

Tea::Screen.blit b, 0, 0

Tea::Screen.update

loop do
  e = Tea::Event.get(true)
  break if e.class == Tea::App::Exit || e.class == Tea::Kbd::Down
end
