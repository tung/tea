# Move the Smiley with the arrow keys, and press Esc to exit.  Identical to
# smile_move.rb, but uses Tea::Event::Dispatch in a controlling class to handle
# events.

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

class SmileControllingState
  def initialize
    @player = Smile.new
    @done = false
  end

  def done?; @done; end
  def update; @player.update; end
  def need_update?; !@player.stopped?; end
  def draw
    Tea::Screen.clear
    @player.draw
  end

  include Tea::Event::Dispatch

  def kbd_down(e)
    case e.key
    when Tea::Kbd::UP     then @player.n true
    when Tea::Kbd::DOWN   then @player.s true
    when Tea::Kbd::LEFT   then @player.w true
    when Tea::Kbd::RIGHT  then @player.e true
    when Tea::Kbd::ESCAPE then @done = true
    end
  end

  def kbd_up(e)
    case e.key
    when Tea::Kbd::UP    then @player.n false
    when Tea::Kbd::DOWN  then @player.s false
    when Tea::Kbd::LEFT  then @player.w false
    when Tea::Kbd::RIGHT then @player.e false
    end
  end
end

Tea.init
Tea::Screen.set_mode 640, 480
state = SmileControllingState.new
until state.done?
  state.update
  state.draw
  Tea::Screen.update

  if e = Tea::Event.get(!state.need_update?)
    state.dispatch_event e
  end
end
