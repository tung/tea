# Test that keyboard events are being picked up.
# Expected results are messages responding to key presses.

require 'tea'

puts <<TEST
You should see a small window.  Try pressing some keys, or Esc to exit.
TEST

Tea.init
Tea::Screen.set_mode 320, 240

loop do
  e = Tea::Event.get(true)

  break if e.class == Tea::App::Exit
  next unless e.class == Tea::Kbd::Down || e.class == Tea::Kbd::Up
  break if e.key == Tea::Kbd::ESCAPE

  out = []

  if e.class == Tea::Kbd::Down
    out << 'down:'
  else
    out << '  up:'
  end

  out << '(' << e.key.to_s << ')'

  mods = (e.mods.select { |mod, down| down }).keys
  out << "++ #{mods.join(' + ')}" if mods.length > 0

  if e.respond_to?(:char)
    out << '='
    out << "\"#{e.char}\""
  end

  puts out.join(' ')
end
