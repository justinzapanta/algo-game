extends Node2D

var mouse_in = false
var is_dragging = false
var offset = Vector2()
var is_selected = false
var is_linked = false
var preview_sprite = null
var parent_node = self.get_parent()

signal test

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	preview_sprite = Sprite2D.new()
	preview_sprite.texture = $Sprite2D.texture
	preview_sprite.modulate = Color(1, 1, 1, 0.5)  # Make the preview semi-transparent
	add_child(preview_sprite)
	preview_sprite.hide()
	
	$"..".connect("block_added", return_block)
	#get_snap_location(preview_sprite)
	
	#preview_sprite.position.x = global_var.other_block_pos_x
	#preview_sprite.position.y = global_var.other_block_pos_y - $Sprite2.texture.get_size().y + 5 
	


func return_block():
	if is_selected:
		is_selected = false
		is_dragging = false
		self.position.x = 50
		self.position.y = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if entered_block:
		
		if Input.is_action_just_released("click"):
				snap_block()
				is_linked=true
				is_selected = false
			#if $ScrollContainer.get_global_rect().has_point(get_global_mouse_position()):
					#print("Hello World")
			
			

	
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:  # Check if the left mouse button is pressed
			if event.pressed && mouse_in:
				is_dragging = true
				is_selected = true
				if self.get_parent() != VBoxContainer:
					offset = get_global_mouse_position() - position
				else:
					print("lolvbox")
				
				if Input.is_action_just_released("click"):
					print("Left mouse button released.")
			elif !event.pressed:
				is_dragging = false
				await get_tree().create_timer(0.1).timeout
				is_selected = false
				
	elif event is InputEventMouseMotion:
		if is_dragging:
			position = get_global_mouse_position() - offset
			global_var.selected_block_pos_x = self.position.x
			global_var.selected_block_pos_y = self.position.y

func _on_body_mouse_entered():
	print("hello")
	emit_signal("test")
	mouse_in = true
	#print("hi")
	if self.get_parent():
		print(self.get_parent())
	if self.get_parent().name == "lol":
		print("hello")
	else:
		print("hi")
	

func _on_body_mouse_exited():
	mouse_in = false

var entered_block = false
func  _on_top_area_area_exited(area):
	if area.is_in_group("block_snap_zone"):
		area_exited(area)

func  _on_top_area_area_entered(area):
	if area.is_in_group("block_snap_zone"):
		area_entered(area)
	#if area.is_in_group("block_body") && preview_sprite.is_visible_in_tree():
		#if !is_selected:
			#if self.position.y > preview_sprite.position.y + 2:
				#await get_tree().create_timer(1).timeout
				#self.position.x = preview_sprite.position.x 
				#self.position.y = preview_sprite.position.y + $Sprite2.texture.get_size().y*2
	
func snap_block():
	
	
	if entered_block && !is_dragging:
		#print("link statusssssss === ", is_linked)
		
		if is_selected:
			if is_linked:
				await get_tree().create_timer(0.1).timeout
				
				self.position.x = global_var.selected_block_pos_x
				self.position.y = global_var.selected_block_pos_y
			else:
				await get_tree().create_timer(0.1).timeout
				get_snap_location(self)
				# Check if the collision happened on top or at the bottom
				#if global_var.other_block_pos_y > self.position.y:
					#print("Collision happened on top.")
					#self.position.x = global_var.other_block_pos_x
					#self.position.y = global_var.other_block_pos_y - $Sprite2.texture.get_size().y + 5 # Adjust as needed for the block size
				#else:
					#print("Collision happened at the bottom.")
					#self.position.x = global_var.other_block_pos_x
					#self.position.y = global_var.other_block_pos_y + $Sprite2.texture.get_size().y - 5
			#print("------------------------------------------")
			#print("DRAGGED x: ", self.position.x, "  |||| y: ", self.position.y)
		is_linked = true
		await get_tree().create_timer(0.1).timeout
		preview_sprite.hide()
		#print("link stat === ", is_linked)
			
				
		
			
			
			
		#else:
			#await get_tree().create_timer(1).timeout
			#print("STATIC x: ", self.position.x, "  |||| y: ", self.position.y)
			#self.position.x = 294
			
func get_snap_location(node):
	print(global_var.selected_block_pos_y)
	
	if global_var.other_block_pos_y > global_var.selected_block_pos_y:
		print("Collision happened on top.")
		node.position.x = global_var.other_block_pos_x
		node.position.y = global_var.other_block_pos_y - $Sprite2D.texture.get_size().y + 5 # Adjust as needed for the block size
	else:
		print("Collision happened at the bottom.")
		node.position.x = global_var.other_block_pos_x
		node.position.y = global_var.other_block_pos_y + $Sprite2D.texture.get_size().y - 5





#
#func _on_area_2d_3_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	#area_entered(area)
#
#func _on_area_2d_3_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	#area_exited(area)
	#print(self.position.x)
	
func area_exited(area):
	if area.is_in_group("block_snap_zone"):
		entered_block = false
		is_linked = false
		preview_sprite.hide()
		
func area_entered(area):
	if area.is_in_group("block_snap_zone"):
		
		entered_block = true
		

		
		if !is_selected:
			global_var.other_block_pos_x = self.position.x
			global_var.other_block_pos_y = self.position.y
			
			print("STATIC x: ", global_var.other_block_pos_x, "  |||| y: ", global_var.other_block_pos_y)
			preview_sprite.show()
			get_snap_location(preview_sprite)



func _on_bottom_area_area_entered(area):
	if area.is_in_group("block_snap_zone"):
		area_entered(area)


func _on_bottom_area_area_exited(area):
	if area.is_in_group("block_snap_zone"):
		area_exited(area)





