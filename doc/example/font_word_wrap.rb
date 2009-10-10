# Test that word-wrapping works.

require 'tea'

puts <<TEST
You should see several lines of bitmapped and SFont text.
Magenta lines indicate the end of the final lines.
Press any key to exit.
TEST

Tea.init
Tea::Screen.set_mode 400, 300

message = "This is a long line. " +
          "I hope it's long enough to wrap around. " +
          "If it wraps, then font word wrapping is working."

font_a = Tea::Font.new('font.bmp', Tea::Font::BITMAP_FONT, :transparent_color => Tea::Color::MAGENTA)
font_b = Tea::Font.new('sfont.png', Tea::Font::SFONT)

lines_a = font_a.word_wrap(message, Tea::Screen.w)
lines_b = font_b.word_wrap(message, Tea::Screen.w)

y_pos = 0
lines_a.each do |line|
  break if y_pos + font_a.h >= Tea::Screen.h / 2
  font_a.draw_to Tea::Screen, 0, y_pos, line
  y_pos += font_a.h
end
Tea::Screen.line lines_a.end_x, 0, lines_a.end_x, y_pos, Tea::Color::MAGENTA

old_y_pos = y_pos
lines_b.each do |line|
  break if y_pos + font_b.h >= Tea::Screen.h
  font_b.draw_to Tea::Screen, 0, y_pos, line
  y_pos += font_b.h
end
Tea::Screen.line lines_b.end_x, old_y_pos, lines_b.end_x, y_pos, Tea::Color::MAGENTA

Tea::Screen.update

begin
  e = Tea::Event.get(true)
end until e.class == Tea::App::Exit || e.class == Tea::Kbd::Down
