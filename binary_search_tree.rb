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
    return if node.nil?

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

  def level_order(&block)
    return block_given? ? traversalChoice(0, &block) : traversalChoice(0)
  end

  def inorder(&block)
    return block_given? ? traversalChoice(1, &block) : traversalChoice(1)
  end

  def preorder(&block)
    return block_given? ? traversalChoice(2, &block) : traversalChoice(2)
  end

  def postorder(&block)
    return block_given? ? traversalChoice(3, &block) : traversalChoice(3)
  end

  def traversalChoice(type) # 0 = level_order, 1 = inorder, 2 = preorder, 3 = postorder
    return [] if @root.nil?

    node_list = []
    case type
    when 0
      levelOrderTraversal(node_list, [@root])
    when 1
      inorderTraversal(node_list, @root)
    when 2
      preorderTraversal(node_list, @root)
    when 3
      postorderTraversal(node_list, @root)
    end
    return node_list.map { |x| x.data } unless block_given?

    node_list.each { |x| yield x }
  end

  def levelOrderTraversal(node_list, level_node_list)
    return if level_node_list.empty?

    temp = []
    level_node_list.each do |node|
      node_list << node
      temp << node.left << node.right
    end
    temp.compact!
    levelOrderTraversal(node_list, temp)
  end

  def inorderTraversal(node_list, node)
    inorderTraversal(node_list, node.left) unless node.left.nil?
    node_list << node
    inorderTraversal(node_list, node.right) unless node.right.nil?
  end

  def preorderTraversal(node_list, node)
    node_list << node
    preorderTraversal(node_list, node.left) unless node.left.nil?
    preorderTraversal(node_list, node.right) unless node.right.nil?
  end

  def postorderTraversal(node_list, node)
    postorderTraversal(node_list, node.left) unless node.left.nil?
    postorderTraversal(node_list, node.right) unless node.right.nil?
    node_list << node
  end

  def height(node)
    node = find(node.data)
    return if node.nil?
    return 0 if node.left.nil? && node.right.nil?

    left = node.left.nil? ? 0 : height(node.left)
    right = node.right.nil? ? 0 : height(node.right)
    
    return 1 +  if left > right
                  left
                else
                  right
                end
  end

  def depth(node)
    depth = 0
    curr_node = @root

    loop do
      return if curr_node.nil?
      return depth if node == curr_node

      if node > curr_node
        curr_node = curr_node.right
      else
        curr_node = curr_node.left
      end
      depth += 1
    end
  end
end
