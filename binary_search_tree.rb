class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end


class Tree
  attr_accessor :root

  def initialize(arr)
    arr.uniq!.sort!
    @root = build_tree(arr)
  end

  def build_tree(arr)
    return if arr.empty?

    middle_idx = arr.length / 2
    return Node.new(arr[middle_idx], build_tree(arr[0...middle_idx]), build_tree(arr[(middle_idx + 1)..-1]))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

a = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
a.pretty_print
