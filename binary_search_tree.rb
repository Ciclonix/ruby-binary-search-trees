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
    arr.sort!.uniq!
    @root = build_tree(arr)
    @i = 0
  end

  def build_tree(arr)
    return if arr.empty?

    middle_idx = arr.length / 2
    return Node.new(arr[middle_idx], build_tree(arr[0...middle_idx]), build_tree(arr[(middle_idx + 1)..-1]))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) unless node.right.nil?
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) unless node.left.nil?
  end

  def insert(data)
    if @root.nil?
      @root = Node.new(data)
      return
    end

    compare(@root, Node.new(data))
  end

  def compare(node, new_node)
    if new_node > node
      if node.right.nil?
        node.right = new_node
      else
        compare(node.right, new_node)
      end
    elsif new_node < node
      if node.left.nil?
        node.left = new_node
      else
        compare(node.left, new_node)
      end
    end
  end

  def delete(data)
    removeNode(@root, data)
  end

  def removeNode(this_node, data)
    return this_node if this_node.nil?

    if this_node.data > data
      this_node.left = removeNode(this_node.left, data)
    elsif this_node.data < data
      this_node.right = removeNode(this_node.right, data)
    else
      return this_node.right if this_node.left.nil?
      return this_node.left if this_node.right.nil?

      successor = getSuccessor(this_node)
      this_node.data = successor.data
      this_node.right = removeNode(this_node.right, successor.data)
    end
    return this_node
  end

  def getSuccessor(node)
    successor = node.right
    until successor.nil? || successor.left.nil?
      successor = successor.left
    end
    return successor
  end

  def find(data)
    return if data.nil?

    node = @root
    loop do
      return node if node.nil? || data == node.data

      if data > node.data
        node = node.right
      else
        node = node.left
      end
    end
  end
end
