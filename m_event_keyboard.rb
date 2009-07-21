# This file holds the key press and modifier events.

require 'sdl'

#
module Tea

  module Event

    # Event generated when a key is pressed down.
    #
    # +key+::   Physical key that was pressed, as a symbol (see key reference).
    # +mods+::  Hash of the active key modifiers.  Values are +true+ or
    #           +false+, and the keys can be: +:l_shift+, +r_shift+, +l_ctrl+,
    #           +r_ctrl+, +l_alt+, +r_alt+, +num_lock+, +caps_lock+, +alt_gr+.
    #           Also, +shift+, +ctrl+ and +alt+ are provided for convenience.
    # +char+::  String character generated by that key and those modifiers.
    #           With Ruby >= 1.9, the encoding of this character is UTF-8,
    #           otherwise it varies with the running environment.
    class KeyDown
      attr_reader :key, :mods, :char
      def initialize(key, mods, char)
        @key = key
        @mods = mods
        @char = char
      end
    end

    # Event generated when a held-down key is released.  +key+ and +mods+ are
    # the same as in KeyDown.
    #
    # +key+::   Physical key that was pressed, as a symbol (see key reference).
    # +mods+::  Hash of the active key modifiers.  Values are +true+ or
    #           +false+, and the keys can be: +:l_shift+, +r_shift+, +l_ctrl+,
    #           +r_ctrl+, +l_alt+, +r_alt+, +num_lock+, +caps_lock+, +alt_gr+.
    #           Also, +shift+, +ctrl+ and +alt+ are provided for convenience.
    class KeyUp
      attr_reader :key, :mods
      def initialize(key, mods)
        @key = key
        @mods = mods
      end
    end

    private

    # Convert a keyboard-related SDL::Event into a Tea event.  For internal use
    # only.
    def Event.translate_keyboard_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::KeyDown
        key = SDL_KEY_TABLE[sdl_event.sym]
        mods = Event.decode_modifiers(sdl_event.mod)

        # Ruby 1.9 uses UTF-8 Unicode encoding.  Below this, who knows how
        # Unicode code points are interpreted?
        if sdl_event.unicode != 0
          unicode_field = "%c"
          ruby_minor = RUBY_VERSION.match(/\.(\d+)\./)
          if ruby_minor && ruby_minor[1].to_i >= 9
            unicode_field = unicode_field.encode('utf-8')
          end
          char = unicode_field % sdl_event.unicode
        else
          char = ''
        end

        out_events.push KeyDown.new(key, mods, char)
      when SDL::Event::KeyUp
        key = SDL_KEY_TABLE[sdl_event.sym]
        mods = Event.decode_modifiers(sdl_event.mod)
        out_events.push KeyUp.new(key, mods)
      end

      out_events
    end

    # Decode the SDL key event mod into a hash of easily consulted key modifier
    # symbols.  For internal use only.
    def Event.decode_modifiers(sdl_key_event_mod)
      mods = {}

      mods[:l_shift] = (sdl_key_event_mod & SDL::Key::MOD_LSHIFT) != 0
      mods[:r_shift] = (sdl_key_event_mod & SDL::Key::MOD_RSHIFT) != 0
      mods[:shift]   = mods[:l_shift] || mods[:r_shift]

      mods[:l_ctrl] = (sdl_key_event_mod & SDL::Key::MOD_LCTRL) != 0
      mods[:r_ctrl] = (sdl_key_event_mod & SDL::Key::MOD_RCTRL) != 0
      mods[:ctrl]   = mods[:l_ctrl] || mods[:r_ctrl]

      mods[:l_alt] = (sdl_key_event_mod & SDL::Key::MOD_LALT) != 0
      mods[:r_alt] = (sdl_key_event_mod & SDL::Key::MOD_RALT) != 0
      mods[:alt]   = mods[:l_alt] || mods[:r_alt]

      mods[:num_lock]  = (sdl_key_event_mod & SDL::Key::MOD_NUM) != 0
      mods[:caps_lock] = (sdl_key_event_mod & SDL::Key::MOD_CAPS) != 0
      mods[:alt_gr]    = (sdl_key_event_mod & SDL::Key::MOD_MODE) != 0

      mods
    end

    # Big fat table of SDL keys to Ruby strings.  For internal use only.
    SDL_KEY_TABLE = {SDL::Key::BACKSPACE => :backspace,
                     SDL::Key::TAB => :tab,
                     #SDL::Key::CLEAR => clear, # ???
                     SDL::Key::RETURN => :enter,
                     SDL::Key::PAUSE => :pause,
                     SDL::Key::ESCAPE => :escape,
                     SDL::Key::SPACE => :space,
                     SDL::Key::EXCLAIM => :exclamation_mark,
                     SDL::Key::QUOTEDBL => :double_quote,
                     SDL::Key::HASH => :hash,
                     SDL::Key::DOLLAR => :dollar,
                     SDL::Key::AMPERSAND => :ampersand,
                     SDL::Key::QUOTE => :quote,
                     SDL::Key::LEFTPAREN => :open_paren,
                     SDL::Key::RIGHTPAREN => :close_paren,
                     SDL::Key::ASTERISK => :asterisk,
                     SDL::Key::PLUS => :plus,
                     SDL::Key::COMMA => :comma,
                     SDL::Key::MINUS => :minus,
                     SDL::Key::PERIOD => :period,
                     SDL::Key::SLASH => :slash,
                     SDL::Key::K0 => :k0,
                     SDL::Key::K1 => :k1,
                     SDL::Key::K2 => :k2,
                     SDL::Key::K3 => :k3,
                     SDL::Key::K4 => :k4,
                     SDL::Key::K5 => :k5,
                     SDL::Key::K6 => :k6,
                     SDL::Key::K7 => :k7,
                     SDL::Key::K8 => :k8,
                     SDL::Key::K9 => :k9,
                     SDL::Key::COLON => :colon,
                     SDL::Key::SEMICOLON => :semicolon,
                     SDL::Key::LESS => :less_than,
                     SDL::Key::EQUALS => :equals,
                     SDL::Key::GREATER => :greater_than,
                     SDL::Key::QUESTION => :question_mark,
                     SDL::Key::AT => :at,
                     SDL::Key::LEFTBRACKET => :open_square_bracket,
                     SDL::Key::BACKSLASH => :backslash,
                     SDL::Key::RIGHTBRACKET => :close_square_bracket,
                     SDL::Key::CARET => :caret,
                     SDL::Key::UNDERSCORE => :underscore,
                     SDL::Key::BACKQUOTE => :backtick,
                     SDL::Key::A => :a,
                     SDL::Key::B => :b,
                     SDL::Key::C => :c,
                     SDL::Key::D => :d,
                     SDL::Key::E => :e,
                     SDL::Key::F => :f,
                     SDL::Key::G => :g,
                     SDL::Key::H => :h,
                     SDL::Key::I => :i,
                     SDL::Key::J => :j,
                     SDL::Key::K => :k,
                     SDL::Key::L => :l,
                     SDL::Key::M => :m,
                     SDL::Key::N => :n,
                     SDL::Key::O => :o,
                     SDL::Key::P => :p,
                     SDL::Key::Q => :q,
                     SDL::Key::R => :r,
                     SDL::Key::S => :s,
                     SDL::Key::T => :t,
                     SDL::Key::U => :u,
                     SDL::Key::V => :v,
                     SDL::Key::W => :w,
                     SDL::Key::X => :x,
                     SDL::Key::Y => :y,
                     SDL::Key::Z => :z,
                     SDL::Key::DELETE => :delete,
                     SDL::Key::KP0 => :np0,
                     SDL::Key::KP1 => :np1,
                     SDL::Key::KP2 => :np2,
                     SDL::Key::KP3 => :np3,
                     SDL::Key::KP4 => :np4,
                     SDL::Key::KP5 => :np5,
                     SDL::Key::KP6 => :np6,
                     SDL::Key::KP7 => :np7,
                     SDL::Key::KP8 => :np8,
                     SDL::Key::KP9 => :np9,
                     SDL::Key::KP_PERIOD => :period,
                     SDL::Key::KP_DIVIDE => :np_divide,
                     SDL::Key::KP_MULTIPLY => :np_multiply,
                     SDL::Key::KP_MINUS => :np_minus,
                     SDL::Key::KP_PLUS => :np_plus,
                     SDL::Key::KP_ENTER => :np_enter,
                     SDL::Key::KP_EQUALS => :np_equals,
                     SDL::Key::UP => :up,
                     SDL::Key::DOWN => :down,
                     SDL::Key::RIGHT => :right,
                     SDL::Key::LEFT => :left,
                     SDL::Key::INSERT => :insert,
                     SDL::Key::HOME => :home,
                     SDL::Key::END => :end,
                     SDL::Key::PAGEUP => :page_up,
                     SDL::Key::PAGEDOWN => :page_down,
                     SDL::Key::F1 => :f1,
                     SDL::Key::F2 => :f2,
                     SDL::Key::F3 => :f3,
                     SDL::Key::F4 => :f4,
                     SDL::Key::F5 => :f5,
                     SDL::Key::F6 => :f6,
                     SDL::Key::F7 => :f7,
                     SDL::Key::F8 => :f8,
                     SDL::Key::F9 => :f9,
                     SDL::Key::F10 => :f10,
                     SDL::Key::F11 => :f11,
                     SDL::Key::F12 => :f12,
                     #SDL::Key::F13 => F13, # Who
                     #SDL::Key::F14 => F14, # has
                     #SDL::Key::F15 => F15, # these?
                     SDL::Key::NUMLOCK => :num_lock,
                     SDL::Key::CAPSLOCK => :caps_lock,
                     SDL::Key::SCROLLOCK => :scroll_lock,
                     SDL::Key::RSHIFT => :r_shift,
                     SDL::Key::LSHIFT => :l_shift,
                     SDL::Key::RCTRL => :r_ctrl,
                     SDL::Key::LCTRL => :l_ctrl,
                     SDL::Key::RALT => :r_alt,
                     SDL::Key::LALT => :l_alt,
                     #SDL::Key::RMETA => right meta, # 'meta' should
                     #SDL::Key::LMETA => left meta,  # be 'alt'?
                     SDL::Key::LSUPER => :l_super,
                     SDL::Key::RSUPER => :r_super,
                     SDL::Key::MODE => :alt_gr,
                     #SDL::Key::HELP => help, # Rare enough to cause problems.
                     SDL::Key::PRINT => :print_screen,
                     SDL::Key::SYSREQ => :sys_req,
                     SDL::Key::BREAK => :break,
                     SDL::Key::MENU => :menu,
                     #SDL::Key::POWER => power, # "Power Macintosh" power key
                     SDL::Key::EURO => :euro, # Some European keyboards need this.
                    }
  end

end
