extends Node2D

var starting_position
var card_slot_is_in

signal hovered
signal hovered_off

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
