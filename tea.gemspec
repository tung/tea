# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tea}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tung Nguyen"]
  s.date = %q{2009-07-29}
  s.description = %q{Tea is a library for making simpler games from a simpler age.
It's designed with these things in mind:

 - 0 is better than 1, and 1 is better than 2.
 - Simplicity beats speed.
 - Value and convenience can sometimes beat simplicity.
 - Procedural beats object-oriented in a dead-heat.
}
  s.email = %q{tunginobi@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "COPYING",
     "COPYING.LESSER",
     "README.rdoc",
     "doc/example/bitmap_draw.rb",
     "doc/example/bitmap_load.rb",
     "doc/example/bitmap_new.rb",
     "doc/example/circles.rb",
     "doc/example/event_app.rb",
     "doc/example/event_keyboard.rb",
     "doc/example/event_mouse.rb",
     "doc/example/init.rb",
     "doc/example/lines.rb",
     "doc/example/point.rb",
     "doc/example/rect.rb",
     "doc/example/screen_set_mode.rb",
     "doc/example/screen_update.rb",
     "doc/example/smile.png",
     "doc/example/smile_bounce.rb",
     "doc/example/smile_move.rb",
     "doc/example/smile_move_2.rb",
     "doc/example/state_app.rb",
     "doc/example/state_keyboard.rb",
     "doc/example/state_mouse.rb",
     "doc/key_constants.textile",
     "doc/key_modifiers.textile",
     "doc/reference.textile",
     "lib/tea.rb",
     "lib/tea/c_bitmap.rb",
     "lib/tea/c_error.rb",
     "lib/tea/m_blitting.rb",
     "lib/tea/m_event.rb",
     "lib/tea/m_event_app.rb",
     "lib/tea/m_event_dispatch.rb",
     "lib/tea/m_event_keyboard.rb",
     "lib/tea/m_event_mouse.rb",
     "lib/tea/m_primitive_drawing.rb",
     "lib/tea/screen.rb"
  ]
  s.homepage = %q{http://github.com/tung/tea}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A simple game development library for Ruby.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubysdl>, [">= 0"])
    else
      s.add_dependency(%q<rubysdl>, [">= 0"])
    end
  else
    s.add_dependency(%q<rubysdl>, [">= 0"])
  end
end
