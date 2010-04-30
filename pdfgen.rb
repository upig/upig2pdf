#coding:utf-8
require 'prawn'

#KINDLE 9.7  14 x 20.3 cm
#A4  21 x 29.7cm
#A4 595.28 x 841.89 
#28.346666666666666666666666666667
#9.7 396.85333333333333333333333333333 575.43323232323232323232323232323
#

file_name = ARGV[0] || 'test.txt'.encode('GBK')



CHN_ESCAPE = { ',' => '，',  '.' => '。',   '\'' => '‘', '"' => '”', ' '=>'　' }


pdf_option = {:page_size=>[396.85, 575.43], :margin=>[0,0,0,2], :compress=>true}
Prawn::Document.generate("#{File.basename(file_name, '.txt')}.pdf", pdf_option) do
  #font 'E:\kindledx\dictionary\pdf\fonts\Serif_Regular.ttf'
  font 'E:\kindledx\dictionary\pdf\fonts\Serif_Regular.ttf'.encode('GBK')
  font_size 14
  File.open(file_name, 'r:GBK') do |f|
    str = f.read
    str.encode!('utf-8', :invalid =>:replace, :undef=>:replace, :replace=>'?' )
    str.gsub!(/([‘“，。])[ ]*/, '\1')
    str.gsub!(/[,'"\. ]/){ |sp| # 替换英文符号
      CHN_ESCAPE[sp]
    } 
    str.gsub!(/^[　\s]*/u, '') #去掉首行空格
    str.gsub!(/^[　\s]*\n/u, '') #去掉空行
    str.gsub!('***', '他妈的')
    text str, :indent_paragraphs=>28, :leading=>0, :align=>:left, :final_gap=>true
  end
end

