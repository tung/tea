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

    BITMAP_FONT_ALPHABET_LENGTH = 256
    SFONT_ALPHABET_LENGTH = 94
    SFONT_ALPHABET_OFFSET = 33
    ASCII_SPACE = 32

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
      end

      @font_type = font_type

      case font_type
      when BITMAP_FONT
        @glyphs = letters_from_bitmap_font(font)
        @alphabet_offset = 0
      when SFONT
        @glyphs = letters_from_sfont(font)
        @alphabet_offset = SFONT_ALPHABET_OFFSET
      end
    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

    # Calculate the pixel width of a string rendered with this font.
    def string_w(string)
      w = 0
      if ruby_version_match = RUBY_VERSION.match(/(\d+)\.(\d+)\.\d+/)
        ruby_major = ruby_version_match[1].to_i
        ruby_minor = ruby_version_match[2].to_i
        if ruby_major >= 1 && ruby_minor >= 9
          case @font_type
          when BITMAP_FONT
            string.codepoints { |pt| w += @glyphs[pt - @alphabet_offset].w }
          when SFONT
            string.codepoints do |pt|
              if pt == ASCII_SPACE
                # Fudge the width of a space.
                w += @glyphs[0].w
              else
                w += @glyphs[pt - @alphabet_offset].w
              end
            end
          end
        else
          case @font_type
          when BITMAP_FONT
            string.length.times { |i| w += @glyphs[string[i] - @alphabet_offset].w }
          when SFONT
            string.length.times do |i|
              pt = string[i]
              if pt == ASCII_SPACE
                # Fudge the width of a space.
                w += @glyphs[0].w
              else
                w += @glyphs[pt - @alphabet_offset].w
              end
            end
          end
        end
      end
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
      if ruby_version_match = RUBY_VERSION.match(/(\d+)\.(\d+)\.\d+/)
        ruby_major = ruby_version_match[1].to_i
        ruby_minor = ruby_version_match[2].to_i
        if ruby_major >= 1 && ruby_minor >= 9
          case @font_type
          when BITMAP_FONT
            string.codepoints do |pt|
              g = @glyphs[pt - @alphabet_offset]
              bitmap.blit g, draw_x, y
              draw_x += g.w
            end
          when SFONT
            string.codepoints do |pt|
              if pt == ASCII_SPACE
                # Use the first char for the space width.
                draw_x += @glyphs[0].w
              else
                g = @glyphs[pt - @alphabet_offset]
                bitmap.blit g, draw_x, y
                draw_x += g.w
              end
            end
          end
        else
          case @font_type
          when BITMAP_FONT
            string.length.times do |i|
              g = @glyphs[string[i] - @alphabet_offset]
              bitmap.blit g, draw_x, y
              draw_x += g.w
            end
          when SFONT
            string.length.times do |i|
              pt = string[i]
              if pt == ASCII_SPACE
                # Use the first char for the space width.
                draw_x += @glyphs[0].w
              else
                g = @glyphs[string[i] - @alphabet_offset]
                bitmap.blit g, draw_x, y
                draw_x += g.w
              end
            end
          end
        end
      end
      string
    end

    private

    # Extract an array of letter glyph Bitmaps from a bitmap font.
    def letters_from_bitmap_font(font_surface)
      unless font_surface.w % BITMAP_FONT_ALPHABET_LENGTH == 0
        raise Tea::Error, "Bitmap font cannot be evenly divided into 256 glyphs (w == #{font_surface.w})", caller
      end

      char_w = font_surface.w / BITMAP_FONT_ALPHABET_LENGTH
      char_h = font_surface.h

      glyphs = if @transparent_color
                 Array.new(BITMAP_FONT_ALPHABET_LENGTH) do |i|
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
                Array.new(BITMAP_FONT_ALPHABET_LENGTH) do |i|
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
      detect_x = 0
      glyphs = Array.new(SFONT_ALPHABET_LENGTH) do |i|
        detect_x += 1 while Tea::Color.mix(*font_surface.get_rgba(font_surface[detect_x, 0])) == Tea::Color::MAGENTA && detect_x < font_surface.w
        raise Tea::Error, "Expected #{SFONT_ALPHABET_LENGTH} letters while loading SFont, got #{i}" if detect_x >= font_surface.w

        char_right_x = detect_x
        char_right_x += 1 while Tea::Color.mix(*font_surface.get_rgba(font_surface[char_right_x, 0])) != Tea::Color::MAGENTA && char_right_x < font_surface.w
        char_w = char_right_x - detect_x
        char_h = font_surface.h

        g = Bitmap.new(char_w, char_h, Color::CLEAR)
        for gy in 0...char_h
          for gx in 0...char_w
            g[gx, gy] = Color.mix(*font_surface.get_rgba(font_surface[detect_x + gx, gy]))
          end
        end

        detect_x = char_right_x

        g
      end

      glyphs
    end

  end

end
