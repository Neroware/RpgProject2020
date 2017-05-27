extends KinematicBody2D

export var current_orientation = "down"
export var texture_path = 0
export var z_relative = true
export var breath = true

var main_sprite
var anim
var current_animation = "none"


func _ready():
	anim = get_node("AnimationPlayer")
	main_sprite = get_node("Main_Sprite")
	set_fixed_process(true)
	if(current_orientation == "down"):
		main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bd.png"))
	elif(current_orientation == "up"):
		main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bu.png"))
	elif(current_orientation == "right" || current_orientation == "left"):
		main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bs.png"))
	else:
		print("!!Misspelled orientation!!")
	##<><><><><><><><><> Ignore this!
		#if(breath == false):
	#	get_node("IdleAnimation").stop()
	get_node("IdleAnimation").stop()
	##<><><><><><><><><>


### Sets the current animation
func set_current_animation(par1Name):
	if(anim != null):
		if(par1Name != "none"):
			if(anim.has_animation(par1Name) == true):
				if(anim.is_playing() == false):
					anim.play(par1Name)
					current_animation = par1Name
			else:
				print("!!Animation does NOT exist: " + par1Name + "!!")
		else:
			anim.stop()
			current_animation = "none"
			if(current_orientation == "down"):
				main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bd.png"))
			elif(current_orientation == "up"):
				main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bu.png"))
			elif(current_orientation == "right" || current_orientation == "left"):
				main_sprite.set_texture(load("res://Assets/Textures/chars/" + str(texture_path) + "/bs.png"))
			else:
				print("!!Misspelled orientation!!")
	else:
		print("!!No AnimationPlayer instance available!!")


### Gets the current animation
func get_current_animation():
	return current_animation


### Sets the texture path ID
func set_path_ID(par1ID):
	texture_path = par1ID


### Gets the texture path ID
func get_path_ID():
	return texture_path


func _fixed_process(delta):
	if(current_orientation == "right"):
		set_scale(Vector2(-1, 1))
	else:
		set_scale(Vector2(1, 1))
	
	if(z_relative == true):
		check_z_relation_with_player()


### Checks the z value which is needed for the relation with the player sprite
func check_z_relation_with_player():
	var player = get_node("../../../Player")
	
	if(player != null):
		if(player.get_pos().y < get_pos().y):
			main_sprite.set_z(3)
		
		if(player.get_pos().y > get_pos().y):
			main_sprite.set_z(0)


### Sets the orientation of the char in the room
func set_orientation(par1Orientation):
	current_orientation = par1Orientation


### Lets the character walk to a direction
func walk(par1Speed, par2Direction, par3AnimateWalking):
	current_orientation = par2Direction
	if(par2Direction == "right"):
		if(par3AnimateWalking == true):
			set_current_scripted_animation("walk_side")
		move(Vector2(par1Speed, 0))
		set_orientation("right")
	
	elif(par2Direction == "left"):
		if(par3AnimateWalking == true):
			set_current_scripted_animation("walk_side")
		move(Vector2(-par1Speed, 0))
		set_orientation("left")
	
	elif(par2Direction == "down"):
		if(par3AnimateWalking == true):
			set_current_scripted_animation("walk_down")
		set_orientation("down")
		move(Vector2(0, par1Speed))
	
	elif(par2Direction == "up"):
		if(par3AnimateWalking == true):
			set_current_scripted_animation("walk_up")
		set_orientation("up")
		move(Vector2(0, -par1Speed))
