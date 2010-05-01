# Sort elements in a natural / alphabetical / human friendly order.
#     require 'natural_sort'
#     
#     NaturalSort::naturalsort ['a1', 'a12', 'a2']   #=> ['a1', 'a2', 'a12']
# or
#     require 'natural_sort_kernel'
#     
#     ['a', 'b', 'A', 'B'].natural_sort              #=> ['A', 'a', 'B', 'b']
module NaturalSort
  VERSION = '1.1.0'
  
  # call-seq:
  #    NaturalSort::naturalsort(object)                     => array
  # 
  # Static method to sort.
  # 
  # *Usage*
  #     NaturalSort::naturalsort ['a1', 'a12', 'a2']     #=> ['a1', 'a2', 'a12']
  # 
  # <tt>object</tt> can by any object that has to_a method.
  def self.naturalsort(object)
    # FIXME avoid copy/paste between naturalsort and natural_sort methods 
    sorted = object.to_a.sort do |a,b|
      sa, sb = a.to_s, b.to_s
      if ((sa.downcase <=> sb.downcase) == 0) then sa <=> sb
      else
        na, nb = check_regexp(sa, sb)
        na <=> nb
      end
    end
  end
  
  # call-seq:
  #    object.natural_sort                     => array
  # 
  # Main method to sort (other are just aliases).
  # 
  # *Usage*
  #     require 'natural_sort'
  #     include NaturalSort
  #     
  #     object.natural_sort         #=> ['a1', 'a2', 'a12']
  # 
  # <tt>object</tt> can by any object that has a method <tt>to_a</tt>
  # 
  # See <tt>natural_sort_kernel.rb</tt> to add natural sort methods to default ruby objects.
  # Enumerable , Array, Range, Set, Hash
  def natural_sort
    sorted = to_a.sort do |a,b|
      sa, sb = a.to_s, b.to_s
      if ((sa.downcase <=> sb.downcase) == 0) then sa <=> sb
      else
        na, nb = check_regexp(sa, sb)
        na <=> nb
      end
    end
  end
  
  private
  
  def self.check_regexp(sa, sb)
    regexp = /(\D+)0*(\d+)/
    ma, mb = regexp.match(sa), regexp.match(sb)
    if (ma and mb)
      l = [sa.size,sb.size].max
      return format(ma, l), format(mb, l)
    else 
      return sa.downcase, sb.downcase
    end
  end
  
  def check_regexp(sa, sb)
    NaturalSort::check_regexp(sa, sb)
  end
  
  # format([a, 1], 3) => a001
  # add leading zero
  def self.format(match_data, length)
    match_data[1].gsub("_", "").downcase + ("%0#{length}d" % match_data[2])
  end
  
  def format(match_data, length)
    NaturalSort::format(match_data, length)
  end
end
