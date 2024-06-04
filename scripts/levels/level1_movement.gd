extends Node2D

var node2d_scene : PackedScene = preload("res://scenes/blocks/code_block_move.tscn")

signal block_added

# Flag to track whether an instance has been added
var instance_added = false

func _ready():
	$code_block_move.connect("test", lmao)

func lmao():
	print("lmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmaolmao")
	
func _process(delta):
	pass

func _on_button_pressed():
	print("-------------------")
	if $ScrollContainer:
		var compiler = $ScrollContainer.get_node("compiler")
		if compiler:
			var compile = compiler.get_node("compile")
			if compile:
				for vbox_child in compile.get_children():
					print("22-------------------")
					if vbox_child is Node2D:
						print("33-------------------")
						for node in vbox_child.get_children():
							if node is Label:
								print("Label Text: %s" % node.text)
							elif node is OptionButton:
								var selected_index = node.get_selected()
								print("OptionButton Selected: %s" % node.get_item_text(selected_index))

func _on_compiler_area_area_entered(area):
	print("hhhhhhhhhhhhhhhhhhhhhhhh")
	if area.is_in_group("block_body") and not instance_added:
		call_deferred("_add_child_after_query", area)
		
func _add_child_after_query(area):
	var instance = node2d_scene.instantiate()
	if instance:
		var scroll_container = $ScrollContainer
		if scroll_container:
			var compiler = scroll_container.get_node("compiler")
			if compiler:
				var compile = compiler.get_node("compile")
				if compile:
					compile.add_child(instance)
					print("Node2D instance added to 'compile'")
					instance_added = true
					emit_signal("block_added")
					await get_tree().create_timer(1).timeout
					instance_added = false
				else:
					print("Could not find 'compile' node under 'Control'")
			else:
				print("Could not find 'Control' node under 'ScrollContainer'")
		else:
			print("Could not find 'ScrollContainer' node")
	else:
		print("Failed to instantiate Node2D")



