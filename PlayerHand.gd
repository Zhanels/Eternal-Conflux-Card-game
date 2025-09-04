extends Node2D

const HAND_COUNT = 2
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_WIDTH = 200

var player_hand = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	# Called when the node enters the scene tree for the first time
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	player_hand.insert(0, card)
	update_hand_positions()

func update_hand_positions():
	for i in range(player_hand.size()):
		# get the new card position based on index
		var new_position = calculate_card_position(i)
		player_hand[i].position = new_position

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return Vector2(x_offset, position.y)
