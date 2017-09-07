## Class that controls a button cross, similar to that of Assassin's Creed
## The blend_in_button() function must be called repeatedly, very useful for area checks!

extends Node2D

## Sprites
var w
var a
var s
var d
 
var w_active = false
var a_active = false
var s_active = false
var d_active = false

var redraw_timer = 0.0


### When called, the button on the button cross will be highlighted for 0.25 seconds
### par1Btn: Button name
func blend_in_button(par1Btn):
	if(par1Btn == "W" || par1Btn == "w"):
		w_active = true
	elif(par1Btn == "A" || par1Btn == "a"):
		a_active = true
	elif(par1Btn == "S" || par1Btn == "s"):
		s_active = true
	elif(par1Btn == "D" || par1Btn == "d"):
		d_active = true
	else:
		print("!!Btn Cross: Wrong input parameter!!")


func _ready():
	w = get_node("Object_Container/W")
	a = get_node("Object_Container/A")
	s = get_node("Object_Container/S")
	d = get_node("Object_Container/D")
	
	set_fixed_process(true)


func _fixed_process(delta):
	redraw_timer += delta
	redraw()
	if(redraw_timer >= 0.25):
		w_active = false
		a_active = false
		s_active = false
		d_active = false
		redraw_timer = 0


### 'Redraw' is probably the wrong name, just checks the opacity of the sprites used in the button cross
func redraw():
	if(w_active == true):
		w.set_opacity(1.0)
	else:
		w.set_opacity(0.5)
	
	if(a_active == true):
		a.set_opacity(1.0)
	else:
		a.set_opacity(0.5)
	
	if(s_active == true):
		s.set_opacity(1.0)
	else:
		s.set_opacity(0.5)
	
	if(d_active == true):
		d.set_opacity(1.0)
	else:
		d.set_opacity(0.5)