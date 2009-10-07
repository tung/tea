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
  # N.B.: Tea uses SGE as its bitmap font backend, which takes the transparent
  #       color to be that of the bottom-left pixel (0, height - 1).  Future
  #       versions of Tea may allow custom transparent colors.
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
  #
  # N.B.: Tea uses SGE as its SFont backend, which misinterprets the format's
  #       specification.  To work around this:
  #
  #   1.  Use the same non-magenta color in the top row, above the characters.
  #   2.  Line the first character flush with the left edge of the image.
  class Font

    # +font_type+ constant for bitmap fonts.
    BITMAP_FONT = :BITMAP_FONT
    SFONT = :SFONT

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

      if options && options.has_key?(:transparent_color)
        @transparent_color = Color.split(options[:transparent_color])
        font.set_color_key SDL::SRCCOLORKEY, @transparent_color
      end

      case font_type
      when BITMAP_FONT
        @glyphs = letters_from_bitmap_font(font)
      when SFONT
        @glyphs = letters_from_sfont(font)
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Calculate the pixel width of a string rendered with this font.
    def string_w(string)
      w = 0
      string.length.times { |i| w += @glyphs[i].w }
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
      # TODO: Handle Ruby 1.8 as well.
      string.codepoints do |pt|
        g = @glyphs[pt]
        bitmap.blit g, draw_x, y
        draw_x += g.w
      end
      string
    end

    private

    # Extract an array of letter glyph Bitmaps from a bitmap font.
    def letters_from_bitmap_font(font_surface)
      unless font_surface.w % 256 == 0
        raise Tea::Error, "Bitmap font cannot be evenly divided into 256 glyphs (w == #{font_surface.w})", caller
      end

      char_w = font_surface.w / 256
      char_h = font_surface.h

      glyphs = if @transparent_color
                 Array.new(256) do |i|
                  g = Bitmap.new(char_w, char_h, Color::CLEAR)
                  for gy in 0...char_h
                    for gx in 0...char_w
                      c = font_surface.get_rgba(font_surface[char_w * i + gx, gy])
                      next if c == @transparent_color
                      g[gx, gy] = Color.mix(*c)
                    end
                  end
                  g
                end
              else
                Array.new(256) do |i|
                  g = Bitmap.new(char_w, char_h, Color::CLEAR)
                  for gy in 0...char_h
                    for gx in 0...char_w
                      g[gx, gy] = Color.mix(*font_surface.get_rgba(font_surface[char_w * i + gx, gy]))
                    end
                  end
                  g
                end
              end

      glyphs
    end

    # Extract an array of letter glyph Bitmaps from an SFont.
    def letters_from_sfont(font_surface)
      raise "TODO: Implement letters_from_sfont."
    end

  end

end
