require './bst.rb'

tree = Tree.new(Array.new(15) {rand(1..100)})

puts "Tree is balanced" if tree.balanced?

print tree.level_order
print tree.preorder
print tree.postorder
print tree.inorder

10.times {tree.insert(rand(100..115))}
puts "Tree is unbalanced" if !tree.balanced?

tree.rebalance
puts "Tree is balanced" if tree.balanced?

print tree.level_order
print tree.preorder
print tree.postorder
print tree.inorder