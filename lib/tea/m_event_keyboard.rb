# This file holds the key press and modifier events.

require 'sdl'

#
module Tea

  module Kbd

    # Superclass for all Kbd events.
    class Event
      @@sdl_key_table = {
          SDL::Key::BACKSPACE => :BACKSPACE,
          SDL::Key::TAB => :TAB,
          #SDL::Key::CLEAR => clear, # ???
          SDL::Key::RETURN => :ENTER,
          SDL::Key::PAUSE => :PAUSE,
          SDL::Key::ESCAPE => :ESCAPE,
          SDL::Key::SPACE => :SPACE,
          SDL::Key::EXCLAIM => :EXCLAMATION_MARK,
          SDL::Key::QUOTEDBL => :DOUBLE_QUOTE,
          SDL::Key::HASH => :HASH,
          SDL::Key::DOLLAR => :DOLLAR,
          SDL::Key::AMPERSAND => :AMPERSAND,
          SDL::Key::QUOTE => :QUOTE,
          SDL::Key::LEFTPAREN => :OPEN_PAREN,
          SDL::Key::RIGHTPAREN => :CLOSE_PAREN,
          SDL::Key::ASTERISK => :ASTERISK,
          SDL::Key::PLUS => :PLUS,
          SDL::Key::COMMA => :COMMA,
          SDL::Key::MINUS => :MINUS,
          SDL::Key::PERIOD => :PERIOD,
          SDL::Key::SLASH => :SLASH,
          SDL::Key::K0 => :K0,
          SDL::Key::K1 => :K1,
          SDL::Key::K2 => :K2,
          SDL::Key::K3 => :K3,
          SDL::Key::K4 => :K4,
          SDL::Key::K5 => :K5,
          SDL::Key::K6 => :K6,
          SDL::Key::K7 => :K7,
          SDL::Key::K8 => :K8,
          SDL::Key::K9 => :K9,
          SDL::Key::COLON => :COLON,
          SDL::Key::SEMICOLON => :SEMICOLON,
          SDL::Key::LESS => :LESS_THAN,
          SDL::Key::EQUALS => :EQUALS,
          SDL::Key::GREATER => :GREATER_THAN,
          SDL::Key::QUESTION => :QUESTION_MARK,
          SDL::Key::AT => :AT,
          SDL::Key::LEFTBRACKET => :OPEN_SQUARE_BRACKET,
          SDL::Key::BACKSLASH => :BACKSLASH,
          SDL::Key::RIGHTBRACKET => :CLOSE_SQUARE_BRACKET,
          SDL::Key::CARET => :CARET,
          SDL::Key::UNDERSCORE => :UNDERSCORE,
          SDL::Key::BACKQUOTE => :BACKTICK,
          SDL::Key::A => :A,
          SDL::Key::B => :B,
          SDL::Key::C => :C,
          SDL::Key::D => :D,
          SDL::Key::E => :E,
          SDL::Key::F => :F,
          SDL::Key::G => :G,
          SDL::Key::H => :H,
          SDL::Key::I => :I,
          SDL::Key::J => :J,
          SDL::Key::K => :K,
          SDL::Key::L => :L,
          SDL::Key::M => :M,
          SDL::Key::N => :N,
          SDL::Key::O => :O,
          SDL::Key::P => :P,
          SDL::Key::Q => :Q,
          SDL::Key::R => :R,
          SDL::Key::S => :S,
          SDL::Key::T => :T,
          SDL::Key::U => :U,
          SDL::Key::V => :V,
          SDL::Key::W => :W,
          SDL::Key::X => :X,
          SDL::Key::Y => :Y,
          SDL::Key::Z => :Z,
          SDL::Key::DELETE => :DELETE,
          SDL::Key::KP0 => :NP0,
          SDL::Key::KP1 => :NP1,
          SDL::Key::KP2 => :NP2,
          SDL::Key::KP3 => :NP3,
          SDL::Key::KP4 => :NP4,
          SDL::Key::KP5 => :NP5,
          SDL::Key::KP6 => :NP6,
          SDL::Key::KP7 => :NP7,
          SDL::Key::KP8 => :NP8,
          SDL::Key::KP9 => :NP9,
          SDL::Key::KP_PERIOD => :NP_PERIOD,
          SDL::Key::KP_DIVIDE => :NP_DIVIDE,
          SDL::Key::KP_MULTIPLY => :NP_MULTIPLY,
          SDL::Key::KP_MINUS => :NP_MINUS,
          SDL::Key::KP_PLUS => :NP_PLUS,
          SDL::Key::KP_ENTER => :NP_ENTER,
          SDL::Key::KP_EQUALS => :NP_EQUALS,
          SDL::Key::UP => :UP,
          SDL::Key::DOWN => :DOWN,
          SDL::Key::RIGHT => :RIGHT,
          SDL::Key::LEFT => :LEFT,
          SDL::Key::INSERT => :INSERT,
          SDL::Key::HOME => :HOME,
          SDL::Key::END => :END,
          SDL::Key::PAGEUP => :PAGE_UP,
          SDL::Key::PAGEDOWN => :PAGE_DOWN,
          SDL::Key::F1 => :F1,
          SDL::Key::F2 => :F2,
          SDL::Key::F3 => :F3,
          SDL::Key::F4 => :F4,
          SDL::Key::F5 => :F5,
          SDL::Key::F6 => :F6,
          SDL::Key::F7 => :F7,
          SDL::Key::F8 => :F8,
          SDL::Key::F9 => :F9,
          SDL::Key::F10 => :F10,
          SDL::Key::F11 => :F11,
          SDL::Key::F12 => :F12,
          #SDL::Key::F13 => F13, # Who
          #SDL::Key::F14 => F14, # has
          #SDL::Key::F15 => F15, # these?
          SDL::Key::NUMLOCK => :NUM_LOCK,
          SDL::Key::CAPSLOCK => :CAPS_LOCK,
          SDL::Key::SCROLLOCK => :SCROLL_LOCK,
          SDL::Key::RSHIFT => :R_SHIFT,
          SDL::Key::LSHIFT => :L_SHIFT,
          SDL::Key::RCTRL => :R_CTRL,
          SDL::Key::LCTRL => :L_CTRL,
          SDL::Key::RALT => :R_ALT,
          SDL::Key::LALT => :L_ALT,
          #SDL::Key::RMETA => right meta, # 'meta' should
          #SDL::Key::LMETA => left meta,  # be 'alt'?
          SDL::Key::LSUPER => :L_SUPER,
          SDL::Key::RSUPER => :R_SUPER,
          SDL::Key::MODE => :ALT_GR,
          #SDL::Key::HELP => help, # Rare enough to cause problems.
          SDL::Key::PRINT => :PRINT_SCREEN,
          SDL::Key::SYSREQ => :SYS_REQ,
          SDL::Key::BREAK => :BREAK,
          SDL::Key::MENU => :MENU,
          #SDL::Key::POWER => power, # "Power Macintosh" power key
          SDL::Key::EURO => :EURO, # Some European keyboards need this.
          }

      # Call a block for each defined Tea key constant.
      def Event.each_key
        @@sdl_key_table.each_value { |key_const| yield key_const }
      end

      protected

      # Convert an SDL keysym to a Tea key constant
      def sdl_keysym_to_key(sdl_keysym)
        @@sdl_key_table[sdl_keysym]
      end

      # Convert SDL key modifier info into an array of active key modifiers.
      def sdl_keymod_to_mods(sdl_keymod)
        mods = {}

        mods[:L_SHIFT] = (sdl_keymod & SDL::Key::MOD_LSHIFT) != 0
        mods[:R_SHIFT] = (sdl_keymod & SDL::Key::MOD_RSHIFT) != 0
        mods[:SHIFT]   = mods[:L_SHIFT] || mods[:R_SHIFT]

        mods[:L_CTRL] = (sdl_keymod & SDL::Key::MOD_LCTRL) != 0
        mods[:R_CTRL] = (sdl_keymod & SDL::Key::MOD_RCTRL) != 0
        mods[:CTRL]   = mods[:L_CTRL] || mods[:R_CTRL]

        mods[:L_ALT] = (sdl_keymod & SDL::Key::MOD_LALT) != 0
        mods[:R_ALT] = (sdl_keymod & SDL::Key::MOD_RALT) != 0
        mods[:ALT]   = mods[:L_ALT] || mods[:R_ALT]

        mods[:NUM_LOCK]  = (sdl_keymod & SDL::Key::MOD_NUM) != 0
        mods[:CAPS_LOCK] = (sdl_keymod & SDL::Key::MOD_CAPS) != 0
        mods[:ALT_GR]    = (sdl_keymod & SDL::Key::MOD_MODE) != 0

        mods
      end
    end

    # Event generated when a key is pressed down.
    #
    # +key+::   Physical key that was pressed, as a symbol (see key reference).
    # +mods+::  Hash of the active key modifiers.  Values are +true+ or
    #           +false+, and the keys can be: +:L_SHIFT+, +:R_SHIFT+,
    #           +:L_CTRL+, +:R_CTRL+, +:L_ALT+, +:R_ALT+, +:NUM_LOCK+,
    #           +:CAPS_LOCK+, +:ALT_GR+.  Also, +:SHIFT+, +:CTRL+ and +:ALT+
    #           are provided for convenience, and Tea key constants with the
    #           same names can be used instead.
    # +char+::  String character generated by that key and those modifiers.
    #           With Ruby >= 1.9, the encoding of this character is UTF-8,
    #           otherwise it varies with the running environment.
    class Down < Event
      attr_reader :key, :mods, :char
      def initialize(sdl_event)
        @key = sdl_keysym_to_key(sdl_event.sym)
        @mods = sdl_keymod_to_mods(sdl_event.mod)

        if sdl_event.unicode != 0
          unicode_field = "%c"

          # Ruby 1.9 uses UTF-8 Unicode encoding.  Otherwise, who knows how
          # Unicode code points are interpreted?
          if ruby_version_match = RUBY_VERSION.match(/(\d+)\.(\d+)\.\d+/)
            ruby_major = ruby_version_match[1].to_i
            ruby_minor = ruby_version_match[2].to_i
            if ruby_major >= 1 && ruby_minor >= 9
              unicode_field = unicode_field.encode('utf-8')
            end
          end

          @char = unicode_field % sdl_event.unicode
        else
          @char = ''
        end
      end
    end

    # Event generated when a held-down key is released.  +key+ and +mods+ are
    # the same as in KeyDown.
    #
    # +key+::   Physical key that was pressed, as a symbol (see key reference).
    # +mods+::  Hash of the active key modifiers.  Values are +true+ or
    #           +false+, and the keys can be: +:L_SHIFT+, +:R_SHIFT+,
    #           +:L_CTRL+, +:R_CTRL+, +:L_ALT+, +:R_ALT+, +:NUM_LOCK+,
    #           +:CAPS_LOCK+, +:ALT_GR+.  Also, +:SHIFT+, +:CTRL+ and +:ALT+
    #           are provided for convenience, and Tea key constants with the
    #           same names can be used instead.
    class Up < Event
      attr_reader :key, :mods
      def initialize(sdl_event)
        @key = sdl_keysym_to_key(sdl_event.sym)
        @mods = sdl_keymod_to_mods(sdl_event.mod)
      end
    end

    # Defaults for Kbd.key_down?, Kbd.mod_active? and Kbd.in_app?.
    @key_states = {}
    Event.each_key { |key| @key_states[key] = false }

    @mod_states = { :L_SHIFT => false, :R_SHIFT => false, :SHIFT => false,
                    :L_CTRL  => false, :R_CTRL  => false, :CTRL  => false,
                    :L_ALT   => false, :R_ALT   => false, :ALT   => false,
                    :NUM_LOCK => false,
                    :CAPS_LOCK => false,
                    :ALT_GR => false }

    @in_app = true

    # Returns +true+ if +key+ is being pressed down.
    def Kbd.key_down?(key)
      if (down = @key_states[key]) == nil
        raise Tea::Error, "Can't find key #{key} to check", caller
      end
      down
    end

    # Returns true if the modifier is 'active'.  For +:L_SHIFT+, +:R_SHIFT+,
    # +:L_CTRL+, +:R_CTRL+, +:L_ALT+, and +:ALT_GR+ (and convenience modifier
    # constants +:SHIFT+, +:CTRL+ and +:ALT+), this means they're being held
    # down.  For +:NUM_LOCK+ and +:CAPS_LOCK+, this means their toggle is on.
    def Kbd.mod_active?(mod)
      if (active = @mod_states[mod]) == nil
        raise Tea::Error, "Can't find modifier #{mod} to check", caller
      end
      active
    end

    # Returns true if the keyboard is focused in the screen window.
    def Kbd.in_app?
      @in_app
    end

    # Update the keyboard state, so that Kbd.key_down? and Kbd.mod_active?
    # provide fresh data.  Called automatically by Event.get.
    def Kbd.update_state(tea_event)
      case tea_event
      when Down, Up
        @key_states[tea_event.key] = (tea_event.class == Down)
        @mod_states.merge! tea_event.mods
      when Lost then   @in_app = false
      when Gained then @in_app = true
      end
    end

    # Define Tea key symbols as constants to avoid typo errors.
    Event.each_key { |key| const_set(key, key) }

    # Extra modifier constants for making modifier detection more consistent.
    SHIFT = :SHIFT
    CTRL = :CTRL
    ALT = :ALT

  end

  module Event

    # Convert a keyboard-related SDL::Event into a Tea event.  For internal use
    # only.
    def Event.translate_keyboard_event(sdl_event)
      out_events = []

      case sdl_event
      when SDL::Event::KeyDown
        out_events.push Kbd::Down.new(sdl_event)
      when SDL::Event::KeyUp
        out_events.push Kbd::Up.new(sdl_event)
      end

      out_events
    end
    private_class_method :translate_keyboard_event

  end

end
