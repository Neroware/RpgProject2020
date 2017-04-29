
extends Node

var input_states = preload("res://Scripts/input_states.gd")
var btn_action = input_states.new("btn_action")

var filepath
var actors
var file_reader
var textbox1
var textbox2
var gui_desicion
var ROOM

var dialogue_running = false
var main_line_finished = true
var ready_for_next_line = true
var btn_input_needed = "True"
var current_main_line


func _ready():
	ROOM = get_node("../..")
	actors = [null, null, null, null, null]
	file_reader = get_node("/root/Game/File_Reader")
	textbox1 = get_node("Text_Box")
	textbox2 = get_node("Text_Box_Char")
	gui_desicion = get_node("GUI_Desicion")
	set_fixed_process(true)


### Each cutscene has BaseCharacters as actors. This function adds them with an ID
func set_actor_with_ID(par1Actor, par2ID):
	actors[par2ID] = par1Actor


### Returns an array of actors that curretly are in the cutscene
func get_actors():
	return actors


### Starts the dialogue
func start_dialogue(par1Filepath, par2PlayerMoveable):
	file_reader.open_dialogue_file(par1Filepath)
	dialogue_running = true
	
	if(par2PlayerMoveable == false):
		get_parent().set_moveable(false)


### --> Fixed Process
### Checks the syntax of the dialogue file and executes the dialogue
func _fixed_process(delta):
	textbox1.set_pos(get_node("../Camera2D").get_pos())
	textbox2.set_pos(get_node("../Camera2D").get_pos())
	gui_desicion.set_pos(get_node("../Camera2D").get_pos() + Vector2(160, 100))
	
	if(dialogue_running == true):
		if(main_line_finished == true):
			if(ready_for_next_line == true):
				current_main_line = file_reader.read_dialogue_line()
				main_line_finished = false
			
			else:
				if(current_main_line == "[Choice]"):
					check_if_passed_to_next_line_after_desicion()
				else:
					check_if_ready_for_next_line()
		
		else:
			if(current_main_line == "[Write]"):
				textbox1.set_opacity(1.0)
				textbox2.set_opacity(0.0)
				var color = file_reader.read_dialogue_line()
				var text = file_reader.read_dialogue_line()
				var speed = float(file_reader.read_dialogue_line())
				btn_input_needed = file_reader.read_dialogue_line()
				textbox1.change_color(color)
				textbox1.write_text_with_constant_speed(text, speed)
				main_line_finished = true
				ready_for_next_line = false
			
			elif(current_main_line == "[Say]"):
				textbox1.set_opacity(0.0)
				textbox2.set_opacity(1.0)
				var actorID = int(file_reader.read_dialogue_line())
				var color = file_reader.read_dialogue_line()
				var text = file_reader.read_dialogue_line()
				var speed = float(file_reader.read_dialogue_line())
				var face_picture = file_reader.read_dialogue_line()
				btn_input_needed = file_reader.read_dialogue_line()
				textbox2.set_picture(load("res://Assets/Textures/chars/" + str(actors[actorID].get_path_ID()) + "/" + str(face_picture) + ".png"))
				textbox2.change_color(color)
				textbox2.write_text_with_constant_speed(text, speed)
				main_line_finished = true
				ready_for_next_line = false
			
			elif(current_main_line == "[CharAction]"):
				var name = file_reader.read_dialogue_line()
				btn_input_needed = file_reader.read_dialogue_line()
				ROOM.perform_action_obj_is_char(name)
				main_line_finished = true
				ready_for_next_line = false
			
			elif(current_main_line == "[PlayerAction]"):
				var name = file_reader.read_dialogue_line()
				btn_input_needed = file_reader.read_dialogue_line()
				ROOM.perform_action_obj_is_player(name)
				main_line_finished = true
				ready_for_next_line = false
			
			elif(current_main_line == "[ObjAction]"):
				var name = file_reader.read_dialogue_line()
				btn_input_needed = file_reader.read_dialogue_line()
				ROOM.perform_action(name)
				main_line_finished = true
				ready_for_next_line = false
			
			elif(current_main_line == "[Choice]"):
				var choice = file_reader.read_dialogue_line()
				var desicion1 = file_reader.read_dialogue_line()
				var desicion2 = file_reader.read_dialogue_line()
				gui_desicion.activate(choice, desicion1, desicion2)
				main_line_finished = true
				ready_for_next_line = false
				
			
			elif(current_main_line == "[End]"):
				textbox1.set_opacity(0.0)
				textbox2.set_opacity(0.0)
				main_line_finished = true
				ready_for_next_line = true
				dialogue_running = false
				get_parent().set_moveable(true)
			
			else:
				print("!!syntax error in dialogue file!!")
				textbox1.set_opacity(0.0)
				textbox2.set_opacity(0.0)
				main_line_finished = true
				ready_for_next_line = true
				dialogue_running = false
				get_parent().set_moveable(true)


### Returns True if the dialogue is still running
func is_dialogue_running():
	return dialogue_running


func check_if_ready_for_next_line():
	if(textbox1.is_textbox_ready() == true && textbox2.is_textbox_ready() == true):
		var a = [false, false, false, false, false]
		var i = 0
		while(i <= 4):
			if(actors[i] != null):
				if(actors[i].get_current_scripted_animation() == "none"):
					a[i] = true
			else:
				a[i] = true
			i += 1
		
		if(a[0] == true && a[1] == true && a[2] == true && a[3] == true && a[4] == true):
			if(btn_input_needed == "True"):
				if(btn_action.check() == 1):
						ready_for_next_line = true
			elif(btn_input_needed == "False"):
				ready_for_next_line = true
			else:
				print("!!Syntax error in dialogue file!!")
				if(btn_action.check() == 1):
					ready_for_next_line = true


func check_if_passed_to_next_line_after_desicion():
		if(gui_desicion.get_desicion() != 0):
			if(gui_desicion.get_desicion() == 1):
				var line
				while(line != "[Desicion1]"):
					line = file_reader.read_dialogue_line()
				gui_desicion.deactivate()
				ready_for_next_line = true
			elif(gui_desicion.get_desicion() == 2):
				var line
				while(line != "[Desicion2]"):
					line = file_reader.read_dialogue_line()
				gui_desicion.deactivate()
				ready_for_next_line = true


