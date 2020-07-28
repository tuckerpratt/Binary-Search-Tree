
class Node
    include Comparable

    attr_accessor :left, :right, :data

    def initialize(value)
        @data = value
        @left = nil
        @right = nil
    end

    def <=>(other)
        @data <=> other.data
    end

end

class Tree

    attr_accessor :single_val_arr, :root
    attr_reader :root

    def initialize(array)
        
        @root = build_tree(array)
        
    end

    def build_tree(arr)
        return if arr.length == 0
    
        arr = arr.uniq.sort
        middle = arr[arr.length / 2]
        root = Node.new(middle)
    
        return root if arr.length == 1
    
        root.left = build_tree(arr[0..(arr.length / 2) - 1])
        root.right = build_tree(arr[(arr.length / 2) + 1..-1])
    
        root
      end

      def pretty_print(node = root, prefix="", is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
        puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data.to_s}"
        pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
      end

      def insert(value)
        node = @root
        return @root = Node.new(value) unless node
    
        while node do
          return node if node.data == value
          if node.data > value
            if node.left
              node = node.left
            else
              node.left = Node.new(value)
              return node.left
            end
          elsif node.data < value
            if node.right
              node = node.right
            else
              node.right = Node.new(value)
              return node.right
            end
          end
        end
      end

    def delete(value) 
        node = find(value)
        parent = find_parent(node)
        successor = find_next(value)

        if !find_next(value) #deletes leaf nodes
            parent.left == node ? parent.left = nil : parent.right = nil
            return
        elsif (node.left && !node.right) || (!node.left && node.right) #deletes nodes with single child
            if node.data < parent.data
                parent.left = node.left
            else
                parent.right = node.right
            end
            return
        else
            replacement = successor.data
            delete(successor.data)
            node.data = replacement
            return
        end

    end

    def level_order
        values = []
        queue = []

        node = @root
        queue.push(node)

        while queue.size > 0 do
            node = queue[0]
            queue.push(node.left) if node.left
            queue.push(node.right) if node.right
            values.push(node.data)
            queue.shift
        end

        return values
    end

    def preorder(node = @root)
        return unless node
        values = []
        values.push(node.data)
        values.push(preorder(node.left)) if node.left
        values.push(preorder(node.right)) if node.right
        return values.flatten
    end

    def inorder(node = @root)
        return unless node
        values = []
        values.push(inorder(node.left)) if node.left
        values.push(node.data)
        values.push(inorder(node.right)) if node.right
        return values.flatten
    end

    def postorder(node = @root)
        return unless node
        values = []
        values.push(postorder(node.left)) if node.left
        values.push(postorder(node.right)) if node.right
        values.push(node.data)
        return values.flatten
    end

    def depth(node = @root)
        return -1 unless node
        left = depth(node.left)
        right = depth(node.right)
        return [left, right].max + 1
    end

    def shortest_depth(node = @root)
        return -1 unless node
        left = shortest_depth(node.left)
        right = shortest_depth(node.right)
        return [left, right].min + 1
    end

    def balanced?(node = @root)
        return depth - shortest_depth > 1 ? false : true
    end

    def rebalance
        arr = self.level_order
        @root = build_tree(arr)
    end

    def find(value)
        node = @root
        return unless node
    
        while node do
          return node if node.data == value
          node = node.data > value ? node.left : node.right
        end
    end

    def find_parent(child_node)
        node = @root
        return unless node

        while node do
            return node if node.left == child_node || node.right == child_node
            node = node.data > child_node.data ? node.left : node.right
        end
    end

    def find_next(value) #returns next highest value, or closest value if nothing higher
        node = find(value)
        return unless node

        return node.left unless node.right

        node = node.right
        while node.left
            node = node.left
        end

        return node
    end

end