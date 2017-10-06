### ---------------------------------------------------------------------------------------------------------------- ###
### This class handles the GUI (shown in the video https://www.youtube.com/watch?v=T_w0Z3R88NA) and the store itself ###
### 							Author: Raoul Zebisch a.k.a The Great Nero											 ###
### ---------------------------------------------------------------------------------------------------------------- ###

extends Node2D

## Class for an item
var item = preload("res://Scenes/item.xml") 

## Button inputs
var input_states = preload("res://Scripts/input_states.gd")
var btn_up = input_states.new("btn_up")
var btn_down = input_states.new("btn_down")
var btn_right = input_states.new("btn_right")
var btn_left = input_states.new("btn_left")
var btn_action = input_states.new("btn_action")
var btn_cancel = input_states.new("btn_cancel")

## Variables for the logic
var stats_control
var gui_inventory
var store
var buy_ready = false
var buy_yes_selected = false

var ready_for_input = false
var ready_for_input2 = false
var active = false
var selection = 0
## Each item in the game can be described as an array with this array form
## [item_type, name, consumable, restores_hp, damage, defense, special_effect, descr, custom_usage_descr, textr path]
var item1_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
var item2_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
var item3_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
var item4_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
var item_price_array = [0, 0, 0, 0]
var item_amount_array = [1, 1, 1, 1]

## Instances of the items themselves
var item1
var item2
var item3
var item4


func _ready():
	store = null
	stats_control = get_node("/root/Game/Game_Node0/Stats_Control")
	gui_inventory = get_node("/root/Game/GUI/Player_GUI/GUI_Items")
	set_fixed_process(true)


func _fixed_process(delta):
	if(get_node("/root/Game/Level_Node").get_child_count() == 1):
		if(active == false):
			set_opacity(0.0)
		else:
			if(buy_ready == false):
				buy_yes_selected = false
				get_node("Info").set_opacity(0.0)
				update_labels()
				check_selection()
				check_btn_input()
				set_opacity(1.0)
			else:
				get_node("Info").set_opacity(1.0)
				check_buy()


### Activates the GUI and the store
### Parameters: You can read :D
func activate(par1ItemArray1, par2ItemArray2, par3ItemArray3, par4ItemArray4, par5PriceArray, par6AmountArray, par7StoreReference):
	get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("000000"))
	
	var player = get_node("/root/Game/Level_Node").get_child(0).get_node("Player")
	player.set_moveable(false)
	player.set_orientation(player.get_orientation() + "_stop")
	
	get_node("/root/Game/GUI/Button_Cross").set_opacity(0.0)
	
	item1_array = par1ItemArray1
	item2_array = par2ItemArray2
	item3_array = par3ItemArray3
	item4_array = par4ItemArray4
	
	item_price_array = par5PriceArray
	item_amount_array = par6AmountArray
	
	## Items get stored in this Node
	var items = get_node("Container_Sprite1/Items")
	if(par1ItemArray1.size() != 0):
		item1 = instance_object(item, "StoreItem1", items)
		item1.import_array(par1ItemArray1)
		item1.set_sprite_pos(Vector2(-36, -57))
	if(par2ItemArray2.size() != 0):
		item2 = instance_object(item, "StoreItem2", items)
		item2.import_array(par2ItemArray2)
		item2.set_sprite_pos(Vector2(-36, -19))
	if(par3ItemArray3.size() != 0):
		item3 = instance_object(item, "StoreItem3", items)
		item3.import_array(par3ItemArray3)
		item3.set_sprite_pos(Vector2(-36, 19))
	if(par4ItemArray4.size() != 0):
		item4 = instance_object(item, "StoreItem4", items)
		item4.import_array(par4ItemArray4)
		item4.set_sprite_pos(Vector2(-36, 57))
	
	## Gets a reference to the store area
	store = par7StoreReference
	
	active = true


### Deactivates the GUI and the store, resets values and deletes the left item instances
func deactivate():
	get_node("/root/Game/GUI/Button_Cross").set_opacity(1.0)
	
	selection = 0
	get_node("/root/Game/Level_Node").get_child(0).get_node("Player").set_moveable(true)
	
	var items = get_node("Container_Sprite1/Items").get_children()
	for i in items:
		i.get_parent().remove_child(i)
	
	get_node("Info/Borders/Border2").set_opacity(0.5)
	
	store = null
	active = false


### Checks the current selection on the GUI and makes marks on the GUI visible
func check_selection():
	get_node("Container_Sprite1/Borders/Border1").set_opacity(0.0)
	get_node("Container_Sprite1/Borders/Border2").set_opacity(0.0)
	get_node("Container_Sprite1/Borders/Border3").set_opacity(0.0)
	get_node("Container_Sprite1/Borders/Border4").set_opacity(0.0)
	get_node("Container_Sprite1/Borders/Border5").set_opacity(0.0)
	if(selection == 0):
		get_node("Container_Sprite1/Borders/Border1").set_opacity(0.5)
	elif(selection == 1):
		get_node("Container_Sprite1/Borders/Border2").set_opacity(0.5)
	elif(selection == 2):
		get_node("Container_Sprite1/Borders/Border3").set_opacity(0.5)
	elif(selection == 3):
		get_node("Container_Sprite1/Borders/Border4").set_opacity(0.5)
	elif(selection == 4):
		get_node("Container_Sprite1/Borders/Border5").set_opacity(0.5)


### Writes Text into all labels on the GUI (boring)
func update_labels():
	var labels1 = get_node("Container_Sprite1/Labels")
	var labels2 = get_node("Container_Sprite2/Labels")
	var amount_labels = [labels1.get_node("Amount_1"), labels1.get_node("Amount_2"), labels1.get_node("Amount_3"), labels1.get_node("Amount_4")]
	var name_labels = [labels1.get_node("Item_Name_1"), labels1.get_node("Item_Name_2"), labels1.get_node("Item_Name_3"), labels1.get_node("Item_Name_4")]
	var label_player_levels = get_node("Container_Sprite2/Labels/Levels_Player")
	var label_price_levels = get_node("Container_Sprite2/Labels/Levels_Price")
	var label_item_descr = get_node("Container_Sprite2/Labels/Item_Descr")
	
	var i1 = 0
	for l_amount in amount_labels:
		l_amount.set_text(str(item_amount_array[i1]) + "x")
		i1 += 1
	
	if(item1_array.size() != 0):
		name_labels[0].set_text(item1_array[1])
	if(item2_array.size() != 0):
		name_labels[1].set_text(item2_array[1])
	if(item3_array.size() != 0):
		name_labels[2].set_text(item3_array[1])
	if(item4_array.size() != 0):
		name_labels[3].set_text(item4_array[1])
	
	label_player_levels.set_text("Lv" + str(stats_control.get_level()))
	
	if(selection >= 0 && selection <= 3):
		label_price_levels.set_text("Lv" + str(item_price_array[selection]))
	
	if(selection == 0):
		if(item1_array.size() != 0):
			label_item_descr.set_text(item1_array[7])
		else:
			label_item_descr.set_text("")
			label_price_levels.set_text("Lv0")
	elif(selection == 1):
		if(item2_array.size() != 0):
			label_item_descr.set_text(item2_array[7])
		else:
			label_item_descr.set_text("")
			label_price_levels.set_text("Lv0")
	elif(selection == 2):
		if(item3_array.size() != 0):
			label_item_descr.set_text(item3_array[7])
		else:
			label_item_descr.set_text("")
			label_price_levels.set_text("Lv0")
	elif(selection == 3):
		if(item4_array.size() != 0):
			label_item_descr.set_text(item4_array[7])
		else:
			label_item_descr.set_text("")
			label_price_levels.set_text("Lv0")
	else:
		label_item_descr.set_text("")
		label_price_levels.set_text("Lv0")


### Checks the input depending on the selection and initiates buy orders
func check_btn_input():
	if(ready_for_input == true):
		if(btn_up.check() == 1):
			get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("000000"))
			if(selection == 0):
				selection = 4
			else:
				selection -= 1
		
		elif(btn_down.check() == 1):
			get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("000000"))
			if(selection == 4):
				selection = 0
			else:
				selection += 1
		
		elif(btn_cancel.check() == 1):
			ready_for_input = false
			ready_for_input2 = false
			buy_yes_selected = false
			buy_ready = false
			deactivate()
		
		elif(btn_action.check() == 1):
			if(selection == 4):
				deactivate()
			elif(selection == 0):
				if(item1_array.size() != 0 && item_amount_array[selection] > 0):
					if(stats_control.get_level() >= item_price_array[selection]):
						buy_yes_selected = false
						buy_ready = true
						get_node("Info/Labels/Prize").set_text("Price: Lv" + str(item_price_array[selection]))
					else:
						get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("ff0000"))
			elif(selection == 1 && item_amount_array[selection] > 0):
				if(item2_array.size() != 0):
					if(stats_control.get_level() >= item_price_array[selection]):
						buy_yes_selected = false
						buy_ready = true
						get_node("Info/Labels/Prize").set_text("Price: Lv" + str(item_price_array[selection]))
					else:
						get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("ff0000"))
			elif(selection == 2 && item_amount_array[selection] > 0):
				if(item3_array.size() != 0):
					if(stats_control.get_level() >= item_price_array[selection]):
						buy_yes_selected = false
						buy_ready = true
						get_node("Info/Labels/Prize").set_text("Price: Lv" + str(item_price_array[selection]))
					else:
						get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("ff0000"))
			elif(selection == 3 && item_amount_array[selection] > 0):
				if(item4_array.size() != 0):
					if(stats_control.get_level() >= item_price_array[selection]):
						buy_yes_selected = false
						buy_ready = true
						get_node("Info/Labels/Prize").set_text("Price: Lv" + str(item_price_array[selection]))
					else:
						get_node("Container_Sprite2/Labels/Levels_Price").add_color_override("font_color", Color("ff0000"))
	else:
		if(btn_action.check() == 0):
			ready_for_input = true


### A function that adds new Nodes very easily and quickly
func instance_object(par1Scene, par2Name, par3Parent):
	var inst = par1Scene.instance()
	inst.set_name(par2Name)
	par3Parent.add_child(inst)
	return inst


### Returns 'true' if the GUI is visible and activated
func is_active():
	return active


### After pressing the Action Button on an Item the GUI asks in an additional dialogue if you item really shall be bought
### This function handles this small dialogue (also shown in the video ;) )
func check_buy():
	if(ready_for_input2 == true):
		if(buy_yes_selected == false):
			get_node("Info/Borders/Border1").set_opacity(0.0)
			get_node("Info/Borders/Border2").set_opacity(0.5)
			if(btn_action.check() == 3):
				ready_for_input2 = false
				buy_ready = false
			elif(btn_right.check() == 1 || btn_left.check() == 1):
				buy_yes_selected = true
		else:
			get_node("Info/Borders/Border1").set_opacity(0.5)
			get_node("Info/Borders/Border2").set_opacity(0.0)
			if(btn_action.check() == 3):
				buy_item(selection)
				ready_for_input2 = false
				buy_ready = false
				get_node("Info/Borders/Border1").set_opacity(0.0)
				get_node("Info/Borders/Border2").set_opacity(0.5)
			elif(btn_right.check() == 1 || btn_left.check() == 1):
				buy_yes_selected = false
		
	else:
		if(btn_action.check() == 0):
			ready_for_input2 = true


### If the item shall be bought this function executes the order
func buy_item(par1Selection):
	item_amount_array[par1Selection] -= 1
	store.set_item_amount(par1Selection, item_amount_array[par1Selection])
	
	var items = get_node("Container_Sprite1/Items")
	var old_item ## The item that will be reparent to the inventory
	if(par1Selection == 0):
		old_item = item1
	elif(par1Selection == 1):
		old_item = item2
	elif(par1Selection == 2):
		old_item = item3
	else:
		old_item = item4
	
	## Reparents the item's instance to the inventory node tree
	var target = gui_inventory.get_node("Item_Container/" + str(old_item.get_type())) ## Node in the Inventory
	items.remove_child(old_item)
	target.add_child(old_item)
	old_item.set_owner(target)
	
	## There is now a free space for a new item instance (we need a new one that store can sell ;) )
	if(par1Selection == 0):
		var new_item = instance_object(item, "StoreItem1", items)
		new_item.import_array(item1_array)
		new_item.set_sprite_pos(Vector2(-36, -57))
		item1 = new_item
	elif(par1Selection == 1):
		var new_item = instance_object(item, "StoreItem2", items)
		new_item.import_array(item2_array)
		new_item.set_sprite_pos(Vector2(-36, -19))
		item2 = new_item
	elif(par1Selection == 2):
		var new_item = instance_object(item, "StoreItem3", items)
		new_item.import_array(item3_array)
		new_item.set_sprite_pos(Vector2(-36, 19))
		item3 = new_item
	else:
		var new_item = instance_object(item, "StoreItem4", items)
		new_item.import_array(item4_array)
		new_item.set_sprite_pos(Vector2(-36, 57))
		item4 = new_item
	
	## Removes the Levels (LV) form the stats (everything costs money)
	stats_control.add_levels(-item_price_array[selection])