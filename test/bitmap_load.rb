# Test if a bitmap can be loaded.
# Expected result
#
#   image size is 32x32

require 'tea'

puts <<TEST
The following line should read "image size is 32x32"
TEST

Tea.init
image = Tea::Bitmap.new('smile.png')
puts "image size is #{image.w}x#{image.h}"
