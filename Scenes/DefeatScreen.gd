extends Node2D
# DefeatScreen.gd

func _ready():
	pass


func _on_button_pressed() -> void:
	# Same as try again
	get_tree().change_scene_to_file("res://Main.tscn")
