# Test that getting, setting and using the clip rectangle all work.
# Expected result is a rectangle of smileys, and one at the bottom-right
# corner.

require 'tea'

puts <<TEST
You should see a rectangle of smileys, and one in the bottom-right corner,
for 10 seconds.

Expected output:
Clip rect is 0, 0, 400, 300
Clip rect is now 50, 50, 290, 185
Clip rect is 0, 0, 400, 300 again
Clip rect is now 368, 268, 32, 32

Actual output:
TEST

Tea.init
Tea::Screen.set_mode 400, 300

puts "Clip rect is #{Tea::Screen.clip.join(", ")}"

smiley = Tea::Bitmap.new('smile.png')

Tea::Screen.clip(50, 50, 290, 185) do
  puts "Clip rect is now #{Tea::Screen.clip.join(", ")}"

  for y in 0..(Tea::Screen.h / smiley.h)
    for x in 0..(Tea::Screen.w / smiley.w)
      Tea::Screen.blit smiley, x * smiley.w, y * smiley.h
    end
  end
end

puts "Clip rect is #{Tea::Screen.clip.join(", ")} again"

Tea::Screen.clip Tea::Screen.w - smiley.w, Tea::Screen.h - smiley.h, smiley.w, smiley.h
Tea::Screen.blit smiley, Tea::Screen.w - smiley.w, Tea::Screen.h - smiley.h

puts "Clip rect is now #{Tea::Screen.clip.join(", ")}"

Tea::Screen.update

sleep 10
