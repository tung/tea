# This file holds the ImageSaving mixin.

require 'sdl'

require 'tea/c_error'

#
module Tea

  # This mixin allows SDL surface-backed classes to be saved as image files.
  #
  # To use, include the mixin and implement an image_saving_buffer method:
  #
  #   include ImageSaving
  #   def image_saving_buffer
  #     @my_sdl_buffer
  #   end
  module ImageSaving

    # Save the object as an image file at the given path.
    #
    # The format is determined by the extension at the end of the path.  ".bmp"
    # will save it as Windows Bitmap image.
    #
    # May raise Tea::Error if the desired image file format can't be
    # determined, or isn't supported.
    def save(path)
      extension_match = /\..+$/.match(path)

      if extension_match
        ext = extension_match[0]
        case ext
        when '.bmp'
          image_saving_buffer.save_bmp(path)
        when '.png'
          raise Tea::Error, "PNG format not supported for saving yet", caller
        else
          raise Tea::Error, "can't determine image format '#{ext}' for saving", caller
        end
      else
        raise Tea::Error, "can't determine desired image file format for #{path}", caller
      end

    rescue SDL::Error => e
      raise Tea::Error, e.message, e.backtrace
    end

  end

end
