# A demo that attempts to test all of Tea::Sound's functionality.

require 'tea'

puts <<TEST
This is a simple sound demo.  Up to 2 sounds can play simultaneously.

Keys:

  [     - Switch to tone 1 (default)
  ]     - Switch to tone 2

  Right - Play tone
  Left  - Stop
  Down  - Pause
  Up    - Resume (unpause)

  s     - Print tone's status (stopped/playing/paused)

  =     - Tone volume +1/8
  -     - Tone volume -1/8
  +     - Master volume +1/8
  _     - Master volume -1/8

  Esc   - Exit demo

--
TEST

Tea.init
Tea::Screen.set_mode 100, 100

tone_sound = Tea::Sound.new('tone.wav')
tones = [tone_sound, tone_sound.clone]

which_tone = 0

done = false
until done
  e = Tea::Event.get(true)
  case e
  when Tea::Kbd::Down
    case e.key

    when Tea::Kbd::OPEN_SQUARE_BRACKET
      which_tone -= 1 if which_tone > 0
      puts "Switched to tone ##{which_tone + 1}"
    when Tea::Kbd::CLOSE_SQUARE_BRACKET
      which_tone += 1 if which_tone < tones.length - 1
      puts "Switched to tone ##{which_tone + 1}"

    when Tea::Kbd::RIGHT
      tones[which_tone].play
      puts "Playing tone ##{which_tone + 1}"
    when Tea::Kbd::LEFT
      tones[which_tone].stop
      puts "Stopping tone ##{which_tone + 1}"
    when Tea::Kbd::DOWN
      tones[which_tone].pause
      puts "Pausing tone ##{which_tone + 1}"
    when Tea::Kbd::UP
      tones[which_tone].resume
      puts "Resuming tone ##{which_tone + 1}"

    when Tea::Kbd::S
      puts "Tone ##{which_tone + 1} is #{tones[which_tone].state.to_s}"

    when Tea::Kbd::EQUALS
      tones[which_tone].volume += 16
      puts "Volume of tone ##{which_tone + 1} raised to #{tones[which_tone].volume} / 128"
    when Tea::Kbd::MINUS
      tones[which_tone].volume -= 16
      puts "Volume of tone ##{which_tone + 1} lowered to #{tones[which_tone].volume} / 128"
    when Tea::Kbd::PLUS
      Tea::Sound.volume += 16
      puts "Master volume raised to #{Tea::Sound.volume} / 128"
    when Tea::Kbd::UNDERSCORE
      Tea::Sound.volume -= 16
      puts "Master volume lowered to #{Tea::Sound.volume} / 128"

    when Tea::Kbd::ESCAPE
      done = true

    end
  when Tea::App::Exit
    done = true
  end
end
