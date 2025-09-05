extends Node2D

const CARD_WIDTH = 200
const HAND_Y_POSITION = 870
const UPDATE_CARD_POS_SPEED = 0.1

var hand = [] # Array of card objects in hand
var card_manager


func _ready():
	card_manager = get_parent().get_node("CardManager")


# Called when new card drawn from deck, and when player stops dragging a card
func add_card_to_hand(card, speed_to_move):
	if card not in hand:
		# Card drawn from deck
		hand.insert(0, card)
		update_hand_positions(speed_to_move)
	else:
		# Move card back to hand position
		animate_card_to_position(card, card.starting_position, speed_to_move)


# Updates positions of all cards in the hand
func update_hand_positions(speed):
	for i in range(hand.size()):
		var new_position = calculate_card_position(i)
		var card = hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)


# Calculates the position for a card based on its index in the hand
func calculate_card_position(index):
	var center_screen_x = get_viewport().size.x / 2
	var total_width = (hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return Vector2(x_offset, HAND_Y_POSITION)


# Animates a card to a target position using a tween
func animate_card_to_position(card, new_position, speed_to_move):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed_to_move)


# Removes a card from the hand and updates remaining card positions
func remove_card_from_hand(card_name):
	# Get the card node from the CardManager
	var card = card_manager.get_node(str(card_name))
	if card in hand:
		hand.erase(card)
		update_hand_positions(UPDATE_CARD_POS_SPEED)
