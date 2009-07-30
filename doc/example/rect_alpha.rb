# Test that alpha for rectangles works.
# Expected results are:
#
# * center:                   red   rectangle (background)
# * top-left:     translucent green rectangle
# * bottom-left:  translucent white rectangle
# * bottom-right: solid       blue  rectangle

require 'tea'

puts <<TEST
You should see for 5 seconds:

 * center:                   red   rectangle (background)
 * top-left:     translucent green rectangle
 * bottom-left:  translucent white rectangle
 * bottom-right: solid       blue  rectangle
TEST

Tea.init
Tea::Screen.set_mode 400, 300

Tea::Screen.rect 100,  75, 200, 150, 0xff0000ff
Tea::Screen.rect   0,   0, 200, 150, 0x00ff0080, :mix => :blend
Tea::Screen.rect 200, 150, 200, 150, 0x0000ff80, :mix => :replace
Tea::Screen.rect   0, 150, 200, 150, 0xffffff80

Tea::Screen.update

sleep 5
