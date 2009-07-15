# This is a demo of 5 smiley faces bouncing around a small screen.

require 'spot'

puts <<TEST
You should see 5 smiley faces bouncing around on a 320x240 screen for 5 seconds.
TEST

class Smiley
  def initialize(bitmap, start_x=0, start_y=0)
    @bitmap = bitmap
    @x = start_x
    @y = start_y
    @dx = rand() * 2 - 1
    @dy = rand() * 2 - 1
  end

  def update
    @x += @dx
    @y += @dy
    @dx = -@dx if @x < 0 || @x + @bitmap.w >= Spot.screen.w
    @dy = -@dy if @y < 0 || @y + @bitmap.h >= Spot.screen.h
  end

  def draw
    Spot.screen.blit @bitmap, @x, @y
  end
end

Spot.init
Spot.screen_mode 320, 240

smile_bitmap = Spot::Bitmap.new('smile.png')
smiles = []
5.times { smiles << Smiley.new(smile_bitmap, rand(288), rand(208)) }

start = Spot.time
until Spot.time >= start + 5000 do
  smiles.each { |s| s.update }
  Spot.screen.clear
  smiles.each { |s| s.draw }
  Spot.screen.flip
  sleep 0.001
end
