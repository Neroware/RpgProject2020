extends Area2D

export var item1_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
export var item2_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
export var item3_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
export var item4_array = ["Others", "Item Name", false, 0, 0, 0, "none", "It's an item!", "none", "res://Assets/Textures/items/base.png"]
export var price_array = [1, 1, 1, 1]
export var amount_array = [1, 2, 99, 0]


var input_states = preload("res://Scripts/input_states.gd")
var btn_action = input_states.new("btn_action")

var gui_store

var triggered = false


func _ready():
	gui_store = get_node("/root/Game/GUI/GUI_Store")
	set_fixed_process(true)


func _fixed_process(delta):
	if(triggered == false):
		check_for_player()
	else:
		if(gui_store.is_active() == false):
			triggered = false


### Checks if the player enters the area and presses the action button
func check_for_player():
	var bodies = get_overlapping_bodies()
	for b in bodies:
		if(b.get_name() == "Player"):
			get_node("/root/Game/GUI/Button_Cross").blend_in_button("D") ## This calls the Button Cross (Source on GitHub!)
			if(btn_action.check() == 1):
				if(get_node("/root/Game/GUI/Player_GUI").is_active() == false):
					gui_store.activate(item1_array, item2_array, item3_array, item4_array, price_array, amount_array, self)
					triggered = true


### Sets the item amounts sold in the store
func set_item_amount(par1ItemID, par2Amount):
	amount_array[par1ItemID] = par2Amount


### Sets the price of an item
func set_item_price(par1ItemID, par2Price):
	price_array[par1ItemID] = par2Price