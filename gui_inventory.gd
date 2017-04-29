### This is the entire script for the Inventory. Basically The GUI for the Inventory IS the entire Inventory. There is no separation.
### Items which are stored in the inventory are instances of the class Item (item.gd) that I also uploaded.
### There are different item groups. Each item group (like Weapons or Food) has a fitting parent node within the tree of the inventory.
### If an item gets added there is just a new child at a parent node like e.g. for the Stone Sword: Item_Container/Weapons/StoneSword
### This class also handles how the sprites of the items appear and the player's input.

extends Node2D

var input_states = preload("res://Scripts/input_states.gd")

var btn_up = input_states.new("btn_up")
var btn_down = input_states.new("btn_down")
var btn_right = input_states.new("btn_right")
var btn_left = input_states.new("btn_left")
var btn_action = input_states.new("btn_action")

var item_container
var current_page = 1
var current_group_pages = 1
var current_group = "Food"
var active = false
var current_selection = 3


func _ready():
	item_container = get_node("Item_Container")
	set_fixed_process(true)


func _fixed_process(delta):
	if(is_active() == true):
		check_btn_input()
		if(get_node("GUI_Item_Info").is_active() == true):
			active = false
	get_node("Container_Sprite/Label 2").set_text(current_group)


### Adds an item to the list
func add_item(par1Item):
	if(item_container.get_node(par1Item.get_type()) != null):
		item_container.get_node(par1Item.get_type()).add_child(par1Item)
	else:
		print("!!Item has an unknown group!!")


### Draws the item list in the inventory section of the GUI
func setup_item_list():
	clean_item_list()
	
	current_group_pages = ceil(float(item_container.get_node(current_group).get_children().size()) / 9.0)
	if(current_group_pages == 0):
		get_node("Container_Sprite/Label3").set_text("1 / 1")
	else:
		get_node("Container_Sprite/Label3").set_text(str(current_page) + " / " + str(current_group_pages))
	
	var items = item_container.get_node(current_group).get_children()
	var array_length = items.size()
	
	var i = 0
	while(i + 9 * (current_page - 1) < array_length && i < 9):
		var index = i + 9 * (current_page - 1)
		var item = items[index]
		if(i == 0 || i == 1 || i == 2):
			item.set_sprite_pos(Vector2(45 * (i - 1), -30))
		elif(i == 3 || i == 4 || i == 5):
			item.set_sprite_pos(Vector2(45 * (i - 4), 15))
		elif(i == 6 || i == 7 || i == 8):
			item.set_sprite_pos(Vector2(45 * (i - 7), 60))
		i += 1


### Totally cleans the drawed item list of the GUI
func clean_item_list():
	for ic in item_container.get_children():
		for i in ic.get_children():
			i.set_sprite_pos(Vector2(-10000, -10000))


### Sets the GUI active or inactive
func set_active(par1Active):
	if(par1Active == false):
		current_selection = 3
	setup_item_list()
	active = par1Active


### Returns True of the GUI is active
func is_active():
	return active


### Sets current item page
func set_current_page(par1Page):
	current_page = par1Page


### Returns current item page
func get_current_page():
	return current_page


### Sets current item group in the inventory section
func set_current_group(par1Group):
	current_group = par1Group


### Returns current item group in the inventory section
func get_current_group():
	return current_group


### Goes to the next item group
func next_group():
	current_page = 1
	current_group_pages = null
	if(current_group == "Weapons"):
		current_group = "Armour"
	elif(current_group == "Armour"):
		current_group = "Food"
	elif(current_group == "Food"):
		current_group = "Quest"
	elif(current_group == "Quest"):
		current_group = "Others"
	elif(current_group == "Others"):
		current_group = "Weapons"
	else:
		current_group = "Weapons"


### Goes to the previous item group
func last_group():
	current_page = 1
	current_group_pages = null
	if(current_group == "Weapons"):
		current_group = "Others"
	elif(current_group == "Others"):
		current_group = "Quest"
	elif(current_group == "Quest"):
		current_group = "Food"
	elif(current_group == "Food"):
		current_group = "Armour"
	elif(current_group == "Armour"):
		current_group = "Weapons"
	else:
		current_group = "Weapons"


### Checks the entire button input of the GUI
func check_btn_input():
	for i in get_node("Container_Sprite/Borders").get_children():
		i.set_opacity(0.0)
	get_node("Container_Sprite/Borders").get_children()[current_selection - 1].set_opacity(0.5)
	
	if(btn_right.check() == 1):
		if(current_selection == 13):
			current_selection = 1
		else:
			current_selection += 1
	if(btn_left.check() == 1):
		if(current_selection == 1):
			current_selection = 13
		else:
			current_selection -= 1
	if(btn_down.check() == 1):
		if(current_selection == 1 || current_selection == 2):
			current_selection = 3
		elif(current_selection == 12 || current_selection == 13):
			current_selection = 1
		elif(current_selection == 3 || current_selection == 4 || current_selection == 5 || current_selection == 6 || current_selection == 7 || current_selection == 8):
			current_selection += 3
		else:
			current_selection = 12
	if(btn_up.check() == 1):
		if(current_selection == 1 || current_selection == 2):
			current_selection = 12
		elif(current_selection == 12 || current_selection == 13):
			current_selection = 9
		elif(current_selection == 6 || current_selection == 7 || current_selection == 8 || current_selection == 9 || current_selection == 10 || current_selection == 11):
			current_selection -= 3
		else:
			current_selection = 1
	if(btn_action.check() == 1):
		if(current_selection == 1):
			last_group()
			setup_item_list()
			current_selection = 1
		elif(current_selection == 2):
			next_group()
			setup_item_list()
			current_selection = 2
		elif(current_selection == 13):
			if(current_page + 1 <= current_group_pages):
				current_page += 1
				setup_item_list()
				current_selection = 13
		elif(current_selection == 12):
			if(current_page - 1 >= 1):
				current_page -= 1
				setup_item_list()
				current_selection = 12
		elif(current_selection == 3 || current_selection == 4 || current_selection == 5 || current_selection == 6 ||
		     current_selection == 7 || current_selection == 8 || current_selection == 9 || current_selection == 10 ||
		     current_selection == 11):
			if(item_container.get_node(current_group).get_child((current_selection - 3) + 9 * (current_page - 1)) != null):
				get_node("GUI_Item_Info").activate(item_container.get_node(current_group).get_child((current_selection - 3) + 9 * (current_page - 1)))
				active = false


### Sets a weapon in the weapon slot
func equipe_weapon(par1Weapon):
	if(get_node("/root/Game/Game_Node0/Stats_Control").get_weapon_slot() != null):
		var old_weapon = get_node("/root/Game/Game_Node0/Stats_Control").get_weapon_slot()
		get_node("../GUI_Stats/Container_Sprite/Equipped_Items/Slot_Weapon").remove_child(old_weapon)
		get_node("Item_Container/Weapons").add_child(old_weapon)
	
	get_node("Item_Container/Weapons").remove_child(par1Weapon)
	get_node("../GUI_Stats/Container_Sprite/Equipped_Items/Slot_Weapon").add_child(par1Weapon)
	par1Weapon.set_sprite_pos(Vector2(33, -6))
	setup_item_list()


### Sets an armour in the weapon slot
func equipe_armour(par1Armour):
	if(get_node("/root/Game/Game_Node0/Stats_Control").get_armour_slot() != null):
		var old_armour = get_node("/root/Game/Game_Node0/Stats_Control").get_armour_slot()
		get_node("../GUI_Stats/Container_Sprite/Equipped_Items/Slot_Armour").remove_child(old_armour)
		get_node("Item_Container/Armour").add_child(old_armour)
	
	get_node("Item_Container/Armour").remove_child(par1Armour)
	get_node("../GUI_Stats/Container_Sprite/Equipped_Items/Slot_Armour").add_child(par1Armour)
	par1Armour.set_sprite_pos(Vector2(33, 35))
	setup_item_list()
