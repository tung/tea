# This is a demo of a smiley face bouncing around a small screen.

require 'sprout'

puts <<TEST
You should see a smiley face bouncing around on a 320x240 screen for 5 seconds.
TEST

class Smiley
  def initialize(bitmap, start_x=0, start_y=0)
    @bitmap = bitmap
    @x = start_x
    @y = start_y
    @dx = rand() * 4 - 2
    @dy = rand() * 4 - 2
  end

  def update
    @x += @dx
    @y += @dy
    @dx = -@dx if @x < 0 || @x + @bitmap.w >= Sprout.screen.w
    @dy = -@dy if @y < 0 || @y + @bitmap.h >= Sprout.screen.h
  end

  def draw
    Sprout.screen.draw @bitmap, @x, @y
  end
end

Sprout.init
Sprout.screen_mode 320, 240

smile_bitmap = Sprout::Bitmap.new('smile.png')
s = Smiley.new(smile_bitmap, rand(288), rand(208))

start = Sprout.time
until Sprout.time >= start + 5000 do
  s.update
  s.draw
  Sprout.screen.flip
  sleep 0.002
end
