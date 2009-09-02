# This file holds the Color module.

#
module Tea

  # The Color module holds utility methods that can mix and split colors.
  module Color

    # Create a color from red, green, blue and optionally alpha parts.
    # All values passed in should be within 0..255 inclusive.
    def Color.mix(red, green, blue, alpha=255)
      ((red   & 0xff) << 24) |
      ((green & 0xff) << 16) |
      ((blue  & 0xff) <<  8) |
       (alpha & 0xff)
    end

    # Break a colour up into its red, green, blue and alpha parts.
    # Returns a 4-element array of the form [red, green, blue, alpha], where
    # each element is within 0..255 inclusive.
    def Color.split(color)
      [(color & 0xff000000) >> 24,
       (color & 0x00ff0000) >> 16,
       (color & 0x0000ff00) >>  8,
       (color & 0x000000ff)]
    end

    CLEAR         = Color.mix(  0,   0,   0,   0)

    BLACK         = Color.mix(  0,   0,   0)
    DARK_RED      = Color.mix(128,   0,   0)
    DARK_GREEN    = Color.mix(  0, 128,   0)
    DARK_YELLOW   = Color.mix(128, 128,   0)
    DARK_BLUE     = Color.mix(  0,   0, 128)
    DARK_MAGENTA  = Color.mix(128,   0, 128)
    DARK_CYAN     = Color.mix(  0, 128, 128)
    DARK_GRAY     = Color.mix(128, 128, 128)

    GRAY          = Color.mix(192, 192, 192)
    RED           = Color.mix(255,   0,   0)
    GREEN         = Color.mix(  0, 255,   0)
    YELLOW        = Color.mix(255, 255,   0)
    BLUE          = Color.mix(  0,   0, 255)
    MAGENTA       = Color.mix(255,   0, 255)
    CYAN          = Color.mix(  0, 255, 255)
    WHITE         = Color.mix(255, 255, 255)

  end

end
