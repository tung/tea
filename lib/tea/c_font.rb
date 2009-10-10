# This file holds the Font class, which is used for drawing text.

require 'sdl'

require 'tea/c_error'
require 'tea/c_bitmap'
require 'tea/m_color'

#
module Tea

  # Fonts are used to draw text.  They do this by mapping characters to images
  # that are loaded when the Font is created.
  #
  # Tea supports bitmap fonts, and Karl Bartel's SFont format.
  #
  # Bitmap fonts (Tea::Font::BITMAP_FONT) are a single row of 256 characters in
  # a BMP or PNG image.  If the image has intrinsic transparency, it will be
  # used by default.  Otherwise, loading the font with the color transparency
  # option will consider one color as the 'transparent color' and no such
  # pixels will be drawn.
  #
  # SFont fonts (Tea::Font::SFONT) are also a single row of character images,
  # but ranging from ASCII 33 to ASCII 127:
  #
  #     ! " # $ % & ' ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : ; < = > ? @
  #     A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ `
  #     a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~
  #
  # SFont uses variable width characters.  Characters are separated by magenta
  # (255, 0, 255) in the top pixel row, so the pixels directly under the
  # magenta strips would be the gaps between characters, e.g.:
  #
  #     ____       ____       ____       ____   <-- magenta strips
  #     ....   #   .... ####  ....  ###  ....
  #     ....  # #  .... #   # .... #   # ....
  #     .... ##### .... ####  .... #     ....   <-- gaps between characters
  #     .... #   # .... #   # .... #   # ....       (can be any color)
  #     .... #   # .... ####  ....  ###  ....
  #
  # The width of a space is not defined in the SFont format, so Tea uses the
  # width of the first character, '!'.
  class Font

    # +font_type+ constant for bitmap fonts.
    BITMAP_FONT = :BITMAP_FONT
    SFONT = :SFONT

    BITMAP_FONT_START = 0
    BITMAP_FONT_LENGTH = 256
    SFONT_START = 33
    SFONT_LENGTH = 94
    CODE_POINT_SPACE = 32

    SFONT_ALPHABET_LENGTH = 94

    # Create a new font from a font file given by +path+.
    #
    # +font_type+ is one of Tea::Font::BITMAP_FONT or Tea::Font::SFONT.  See
    # Tea::Font for font format details.
    #
    # Optional hash arguments:
    #
    #   +:transparent_color+::  If +font_type+ is Tea::Font::BITMAP_FONT, this
    #                           is the color that should not be drawn when
    #                           rendering text.  Default: Tea::Color::MAGENTA.
    #
    # May raise Tea::Error on failure.
    def initialize(path, font_type, options=nil)
      font = SDL::Surface.load(path)
      transparent_color = options ? options[:transparent_color] : nil
      @font_type = font_type

      case font_type
      when BITMAP_FONT
        @glyphs = letters_from_bitmap_font(font, transparent_color)
      when SFONT
        @glyphs = letters_from_sfont(font, transparent_color)
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Calculate the pixel width of a string rendered with this font.
    def string_w(string)
      w = 0
      each_code_point(string) { |pt| w += get_glyph_w(pt) }
      w
    end

    # Get the height of the font's characters.
    def h
      # Nothing special about 0, all chars are the same height.
      @glyphs[0].h
    end

    # Write the given string onto the bitmap at (x, y).
    def draw_to(bitmap, x, y, string)
      draw_x = x
      each_code_point(string) do |pt|
        glyph = get_glyph(pt)
        if glyph
          bitmap.blit glyph, draw_x, y
          draw_x += glyph.w
        else
          draw_x += get_glyph_w(pt)
        end
      end

      string
    end

    private

    # Extract an array of letter glyph Bitmaps from a bitmap font.
    def letters_from_bitmap_font(font_surface, transparent_color)
      unless font_surface.w % BITMAP_FONT_LENGTH == 0
        raise Tea::Error, "Bitmap font cannot be evenly divided into #{BITMAP_FONT_LENGTH} glyphs (w == #{font_surface.w})", caller
      end

      char_w = font_surface.w / BITMAP_FONT_LENGTH
      char_h = font_surface.h
      trans_rgba = transparent_color ? Color.split(transparent_color) : nil

      glyphs = Array.new(BITMAP_FONT_LENGTH) do |char|
        glyph = Bitmap.new(char_w, char_h, Color::CLEAR)
        for gy in 0...char_h
          for gx in 0...char_w
            color = font_surface.get_rgba(font_surface[char_w * char + gx, gy])
            glyph[gx, gy] = Color.mix(*color) unless color == trans_rgba
          end
        end
        glyph
      end

      glyphs
    end

    # Extract an array of letter glyph Bitmaps from an SFont.
    def letters_from_sfont(font_surface, transparent_color)
      detect_x = 0
      glyphs = Array.new(SFONT_LENGTH) do |i|
        detect_x += 1 while Tea::Color.mix(*font_surface.get_rgba(font_surface[detect_x, 0])) == Tea::Color::MAGENTA && detect_x < font_surface.w
        raise Tea::Error, "Expected #{SFONT_LENGTH} letters while loading SFont, got #{i}" if detect_x >= font_surface.w

        char_right_x = detect_x
        char_right_x += 1 while Tea::Color.mix(*font_surface.get_rgba(font_surface[char_right_x, 0])) != Tea::Color::MAGENTA && char_right_x < font_surface.w
        char_w = char_right_x - detect_x
        char_h = font_surface.h
        trans_rgba = transparent_color ? Color.split(transparent_color) : nil

        glyph = Bitmap.new(char_w, char_h, Color::CLEAR)
        for gy in 0...char_h
          for gx in 0...char_w
            color = font_surface.get_rgba(font_surface[detect_x + gx, gy])
            glyph[gx, gy] = Color.mix(*color) unless color == trans_rgba
          end
        end

        detect_x = char_right_x

        glyph
      end

      glyphs
    end

    # Run a block for each code point of the string.
    def each_code_point(string)
      if ruby_version_match = RUBY_VERSION.match(/(\d+)\.(\d+)\.\d+/)
        ruby_major = ruby_version_match[1].to_i
        ruby_minor = ruby_version_match[2].to_i
        if ruby_major >= 1 && ruby_minor >= 9
          string.codepoints do |pt|
            yield pt
          end
        else
          string.length.times do |i|
            pt = string[i]
            yield pt
          end
        end
      end
    end

    # Get the designated width of the glyph associated with the code point.
    def get_glyph_w(code_point)
      case @font_type
      when BITMAP_FONT
        @glyphs[code_point].w
      when SFONT
        if SFONT_START <= code_point && code_point < SFONT_START + SFONT_LENGTH
          @glyphs[code_point - SFONT_START].w
        elsif code_point == CODE_POINT_SPACE
          # Substitute with first char width, like SFont reference library.
          @glyphs[0].w
        else
          0
        end
      end
    end

    # Get the glyph bitmap for the given code point.  May return nil if the
    # code point doesn't map to any glyph.
    def get_glyph(code_point)
      case @font_type
      when BITMAP_FONT
        @glyphs[code_point]
      when SFONT
        if SFONT_START <= code_point && code_point < SFONT_START + SFONT_LENGTH
          @glyphs[code_point - SFONT_START]
        else
          nil
        end
      end
    end


  end

end
