# Test that alpha for rectangles works.
# Expected results are:
#
# * center:                   red   rectangle (background)
# * top-left:     translucent green rectangle
# * bottom-left:  translucent white rectangle
# * bottom-right: solid       blue  rectangle

require 'tea'

puts <<TEST
You should see:

 * center:                   red   rectangle (background)
 * top-left:     translucent green rectangle
 * bottom-left:  translucent white rectangle
 * bottom-right: solid       blue  rectangle

A smaller box with these same rectangles should appear in the top-right.  It
can be moved with the arrow keys.

Press ESC key to exit.
TEST

Tea.init
Tea::Screen.set_mode 400, 300

x, y = 205, 15
up, down, left, right = false, false, false, false
wait_for_event = true

b = Tea::Bitmap.new(180, 130, 0x00000000)
b.rect 45, 32, 90, 65, 0xff0000ff
b.rect  0,  0, 90, 65, 0x00ff0080, :mix => :blend
b.rect 90, 65, 90, 65, 0x0000ff80, :mix => :replace
b.rect  0, 65, 90, 65, 0xffffff80

begin
  Tea::Screen.clear

  Tea::Screen.rect 100,  75, 200, 150, 0xff0000ff
  Tea::Screen.rect   0,   0, 200, 150, 0x00ff0080, :mix => :blend
  Tea::Screen.rect 200, 150, 200, 150, 0x0000ff80, :mix => :replace
  Tea::Screen.rect   0, 150, 200, 150, 0xffffff80

  Tea::Screen.blit b, x, y

  Tea::Screen.update
  e = Tea::Event.get(wait_for_event)
  case e
  when Tea::Kbd::Down
    case e.key
    when Tea::Kbd::UP then up = true
    when Tea::Kbd::DOWN then down = true
    when Tea::Kbd::LEFT then left = true
    when Tea::Kbd::RIGHT then right = true
    end
  when Tea::Kbd::Up
    case e.key
    when Tea::Kbd::UP then up = false
    when Tea::Kbd::DOWN then down = false
    when Tea::Kbd::LEFT then left = false
    when Tea::Kbd::RIGHT then right = false
    end
  end
  wait_for_event = !(up || down || left || right)
  x -= 1 if left
  x += 1 if right
  y -= 1 if up
  y += 1 if down
end until e.class == Tea::App::Exit || (e.class == Tea::Kbd::Down && e.key == Tea::Kbd::ESCAPE)
