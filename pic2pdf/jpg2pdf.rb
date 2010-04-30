
# kindle :DX的824*1200的分辨率
# 我的设置是824*1200或780*1080，这样会好很多。
# 西瓜是784*1050 如果只考虑DX，就用784  会小10%左右
# 铜板建议是我建议就用824*1200
# 看杂志用1100*1600这个分辨率，横屏竖屏效果都会很不错，漫画有锯齿


require 'mini_magick'
require 'prawn'

input_path = ARGV[0]
base_name = File.basename(input_path)
temp_path = 'pdf_out_temp'

$pdf_option = {:page_size=>[396.85, 575.43], :margin=>[0,0,0,2], :compress=>true}

Dir.mkdir(temp_path) unless File.exist?(temp_path)
output_file_name = "#{base_name}.pdf"

Prawn::Document.generate("#{output_file_name}", $pdf_option) do
  first_page = true
  Dir.glob(File.join(input_path, '*.jpg')) do |f|
    image = MiniMagick::Image.from_file(f)
    image.rotate "90" if image[:width]>image[:height] 
    image.resize "784x1050"
    file_name = File.join(temp_path, File.basename(f))
    image.write(file_name)
    start_new_page if !first_page
    first_page = false
    image file_name , :fit =>[396.85, 575.43]
  end
end

