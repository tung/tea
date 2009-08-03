# Test that anti-aliased lines work as expected.
# Anti-aliased lines in replace mode should just overwrite the RGBA of the
# pixels it affects.  In blend mode, the line RGB and destination RGB should be
# blended according to their ratio, while the final alpha should be the sum of
# the line and destination alpha values.

require 'tea'

puts <<TEST
You should see 16 green lines in a wheel, with a green dot in the center,
against a grey square.

Press any key to exit.
TEST

Tea.init
Tea::Screen.set_mode 400, 300

b = Tea::Bitmap.new(250, 250, 0x00000000)
CENTER_X = b.w / 2
CENTER_Y = b.h / 2
LINE_CENTER_CLEARANCE = 10
LINE_LENGTH = 100
LINE_COLOR = 0x00ff0080
SPOKES = 16

Tea::Screen.rect 150, 100, 100, 100, 0x404040ff

b.line CENTER_X, CENTER_Y, CENTER_X, CENTER_Y, LINE_COLOR, :antialias => true, :mix => :replace

SPOKES.times do |n|
  angle = n * Math::PI * 2 / SPOKES
  x1 = CENTER_X +  LINE_CENTER_CLEARANCE                * Math.cos(angle)
  y1 = CENTER_Y +  LINE_CENTER_CLEARANCE                * Math.sin(angle)
  x2 = CENTER_X + (LINE_CENTER_CLEARANCE + LINE_LENGTH) * Math.cos(angle)
  y2 = CENTER_Y + (LINE_CENTER_CLEARANCE + LINE_LENGTH) * Math.sin(angle)
  b.line x1, y1, x2, y2, LINE_COLOR, :antialias => true, :mix => n.even? ? :blend : :replace
end

Tea::Screen.blit b, (Tea::Screen.w - b.w) / 2, (Tea::Screen.h - b.h) / 2
Tea::Screen.update
begin
  e = Tea::Event.get(true)
end until e.class == Tea::App::Exit || e.class == Tea::Kbd::Down
