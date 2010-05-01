#coding:GBK
require 'rubygems'
require 'prawn'
require 'optparse'
require 'jcode'
require 'iconv'  
require 'rchardet'
require 'ftools'

exit if Object.const_defined?(:Ocra)

class String  
  def to_gbk(src_encoding='UTF-8')
    return self if src_encoding.upcase.strip=='GBK'
    Iconv.iconv("GBK//IGNORE","#{src_encoding}//IGNORE",self).to_s  
  end  
  def to_utf8(src_encoding='GBK')
    return self if src_encoding.upcase.strip=='UTF-8'
    Iconv.iconv("UTF-8//IGNORE","#{src_encoding}//IGNORE",self).to_s  
  end  
end

#KINDLE 9.7  14 x 20.3 cm
#A4  21 x 29.7cm
#A4 595.28 x 841.89 
#28.346666666666666666666666666667
#9.7 396.85333333333333333333333333333 575.43323232323232323232323232323
#


options = {}

optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner =<<'EOF'
批量转换txt文件为pdf文档(Kindle使用）
1. 自动排版txt文件
2. 自动调整pdf格式
3. 自动识别编码格式
使用方法:
  upig2pdf [options] file_name"
EOF
  options[:output] = ''
  opts.on( '-o', '--output output_name', '指定输出文件名(只用到了路径)') do |f|
    options[:output] = f 
  end

  opts.on( '-h', '--help', '帮助' ) do
    puts opts
    exit
  end
end


optparse.parse!

if options[:output]=='' 
  output_path = '.'
else
  output_path = File.dirname(options[:output])
end

file_name = ARGV[0] || 'test.txt'.encode('GBK')

orign_input_file = ARGV.join(' ') 
orign_input_file.strip!

file_type = File.extname(orign_input_file)
file_title = File.basename(orign_input_file, file_type)
script_path = File.expand_path(File.dirname(__FILE__))

output_bare_file_name = file_title+'.pdf'
output_file_name = File.join(output_path, output_bare_file_name)

CHN_ESCAPE = { ',' => '，',  '.' => '。',   '\'' => '‘', '"' => '”', ' '=>'　' }


$pdf_option = {:page_size=>[396.85, 575.43], :margin=>[0,0,0,2], :compress=>true}
Prawn::Document.generate("#{output_file_name}", $pdf_option) do
  font 'font.ttf'
  font_size 14
  File.open(orign_input_file, 'rb') do |f|
    src_str = f.read

    encode_det = CharDet.detect(src_str[0..100])
    encoding = encode_det['encoding'].upcase
    confidence = encode_det['confidence']
    $stderr.puts '编码不能正确识别' if confidence <0.1
    puts 'begin'

    src_str_utf8 = src_str.to_utf8(encoding)

    src_str_utf8.gsub!(/([‘“，。])[ ]*/, '\1')
    src_str_utf8.gsub!(/[,'"\. ]/){ |sp| # 替换英文符号
      CHN_ESCAPE[sp]
    } 
    src_str_utf8.gsub!(/^[　\s]*/u, '') #去掉首行空格
    src_str_utf8.gsub!(/^[　\s]*\n/u, '') #去掉空行
    #src_str_utf8.gsub!('***', '他妈的')
    text src_str_utf8, :indent_paragraphs=>28, :leading=>0, :align=>:left, :final_gap=>true
  end
end

