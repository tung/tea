# Move the Smiley face with the arrow keys.  Press Esc to exit.

require 'tea'

class Smile
  def initialize
    @bitmap = Tea::Bitmap.new('smile.png')
    @x = (Tea::Screen.w - @bitmap.w) / 2
    @y = (Tea::Screen.h - @bitmap.h) / 2
    @dx = @dy = 0
  end

  def n(move) @dy += move ? -1 : 1 end
  def s(move) @dy += move ? 1 : -1 end
  def e(move) @dx += move ? 1 : -1 end
  def w(move) @dx += move ? -1 : 1 end
  def stopped?; @dx == 0 && @dy == 0; end

  def update
    @x += @dx
    @y += @dy
  end

  def draw
    Tea::Screen.blit @bitmap, @x, @y
  end
end

Tea.init
Tea::Screen.set_mode 640, 480
player = Smile.new
wait_for_event = true
loop do
  player.update
  Tea::Screen.clear
  player.draw
  Tea::Screen.update

  if e = Tea::Event.get(wait_for_event)
    break if e.class == Tea::App::Exit

    case e
    when Tea::Kbd::Down then move = true
    when Tea::Kbd::Up   then move = false
    else next
    end

    case e.key
    when Tea::Kbd::UP     then player.n(move)
    when Tea::Kbd::DOWN   then player.s(move)
    when Tea::Kbd::RIGHT  then player.e(move)
    when Tea::Kbd::LEFT   then player.w(move)
    when Tea::Kbd::ESCAPE then break
    end

    wait_for_event = player.stopped?
  end
end
