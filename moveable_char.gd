extends "res://Scripts/basic_char_new.gd"

export var waypoints = [null, null, null, null, null, null, null, null]
export var looping = false
export var speed = 1.0

var target_pos = Vector2(0.0, 0.0)
var moving = false
var current_waypoint_index = 0


func _ready():
	set_fixed_process(true)


func start_moving():
	target_pos = waypoints[current_waypoint_index]
	moving = true


func _fixed_process(delta):
	if(moving == true):
		if(is_waypoint_reached() == false):
			move_to_current_waypoint(delta)
		else:
			set_current_scripted_animation("none")
			current_waypoint_index += 1
			if(current_waypoint_index <= 7):
				if(waypoints[current_waypoint_index] == null):
					if(looping == false):
						moving = false
						current_waypoint_index = 0
						target_pos = Vector2(0, 0)
					else:
						current_waypoint_index = 0
						target_pos = waypoints[current_waypoint_index]
				else:
					target_pos = waypoints[current_waypoint_index]
			else:
				if(looping == false):
					moving = false
					current_waypoint_index = 0
					target_pos = Vector2(0, 0)
				else:
					current_waypoint_index = 0
					target_pos = waypoints[current_waypoint_index]


func move_to_current_waypoint(delta):
	var movement_v = Vector2(0, 0)
	var current_pos = get_pos()
	
	movement_v = target_pos - current_pos
	movement_v *= (1 / sqrt(movement_v.x * movement_v.x + movement_v.y * movement_v.y)) * speed
	
	if(abs(movement_v.x) > abs(movement_v.y)):
		if(movement_v.x <= 0):
			current_orientation = "left"
		else:
			current_orientation = "right"
	else:
		if(movement_v.y <= 0):
			current_orientation = "up"
		else:
			current_orientation = "down"
	if(current_orientation == "left" || current_orientation == "right"):
		set_current_scripted_animation("walk_side")
	elif(current_orientation == "up"):
		set_current_scripted_animation("walk_up")
	elif(current_orientation == "down"):
		set_current_scripted_animation("walk_down")
	else:
		print("!!Misspelled orientation!!")
	
	move(movement_v)


func is_waypoint_reached():
	if(get_pos().x - 1 <= target_pos.x && get_pos().x + 1 >= target_pos.x):
		if(get_pos().y - 1 <= target_pos.y && get_pos().y + 1 >= target_pos.y):
			return true
		else:
			return false
	else:
		return false


func is_moving():
	return moving


func get_waypoint_array():
	return waypoints


func set_waypoint_with_index(par1Waypoint, par2Index):
	waypoints[par2Index] = par1Waypoint
