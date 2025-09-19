extends Node2D
# VictoryScreen.gd

func _ready():
	# You can add victory animations, sounds, etc. here
	pass



func _on_button_pressed() -> void:
	# Same as try again
	get_tree().change_scene_to_file("res://Main.tscn")
