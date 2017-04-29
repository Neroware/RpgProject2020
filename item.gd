
extends Node

var item_type = "undefined"
var name = "..."
var consumable = false
var restores_hp = 0
var damage = 0
var defense = 0
var special_effect = "none"
var descr = "This is an item"
var custom_usage_descr = "none"

var base_texture = preload("res://Assets/Textures/items/base.png")

var sprite


func _ready():
	sprite = get_node("Sprite")
	set_sprite_pos(Vector2(-10000, -10000))
	#use_base_texture()


func get_sprite_textr():
	return sprite.get_texture()


func set_sprite_textr(par1Textr):
	sprite = get_node("Sprite")
	sprite.set_texture(par1Textr)


func set_sprite_pos(par1Pos):
	sprite.set_pos(par1Pos)


func get_sprite_pos():
	return sprite.get_pos()


func set_type(par1Type):
	item_type = par1Type


func get_type():
	return item_type


func set_consumable(par1Consumable):
	consumable = par1Consumable


func get_consumable():
	return consumable


func set_restored_hp(par1Hp):
	restores_hp = par1Hp


func get_restored_hp():
	return restores_hp


func set_attack_damage(par1Dmg):
	damage = par1Dmg


func get_attack_damage():
	return damage


func set_defense(par1Defense):
	defense = par1Defense


func get_defense():
	return defense


func set_special_effect(par1Effect):
	special_effect = par1Effect


func get_special_effect():
	return special_effect


func set_description(par1Descr):
	descr = par1Descr


func get_description():
	return descr


func use_base_texture():
	sprite.set_texture(base_texture)


func set_name(par1Name):
	name = par1Name


func get_name():
	return name


func set_custom_usage_descr(par1Descr):
	custom_usage_descr = par1Descr


func get_custom_usage_descr():
	return custom_usage_descr


func use():
	if(consumable == true):
		get_parent().remove_child(self)
