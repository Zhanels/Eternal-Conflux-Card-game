extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1
const DEFAULT_CARD_SCALE = 0.8
const CARD_BIGGER_SCALE = 0.85
const CARD_SMALLER_SCALE = 0.6

var screen_size
var card_being_dragged
var is_hovering_on_card
var player_hand_reference
var played_monster_card_this_turn = false
var selected_monster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InPutManager".connect("left_mouse_button_released", on_left_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y))


#func card_clicked(card):
	## Check if it's an opponent card being clicked
	#if card in $"../BattleManager".opponent_cards_on_battlefield:
		#if selected_monster && $"../BattleManager".player_is_attacking == false:
			#$"../BattleManager".enemy_card_selected(card)
		#return
		
func card_clicked(card):
	# Check if it's an opponent card being clicked
	if card in $"../BattleManager".opponent_cards_on_battlefield:
		if selected_monster:
			$"../BattleManager".enemy_card_selected(card)
		else:
			print("No selected monster")
		return
	
	# Check if card on battlefield or in hand
	if card.card_slot_card_is_in:
		# Don't allow actions during opponent's turn or while attacking
		if $"../BattleManager".is_opponents_turn:
			return
		if $"../BattleManager".player_is_attacking:
			return
		
		# Card on battlefield - check if it can attack
		if card in $"../BattleManager".player_cards_that_attacked_this_turn:
			return
		
		# Only Monster cards can attack
		if card.card_type != "Monster":
			return
		
		if $"../BattleManager".opponent_cards_on_battlefield.size() == 0:
			$"../BattleManager".direct_attack(card, "Player")
		else:
			select_card_for_battle(card)
	else:
		# Card in hand
		start_drag(card)

func select_card_for_battle(card):
	# Check if monster already selected
	if selected_monster:
		# If this card already selected
		if selected_monster == card:
			card.position.y += 20
			selected_monster = null
		# If different card selected
		else:
			selected_monster.position.y += 20
			selected_monster = card
			card.position.y -= 20
	else:
		selected_monster = card
		card.position.y -= 20


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)


func finish_drag():
	card_being_dragged.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		# Card dropped in empty slot
		
		# Check if already played a card this turn (any type)
		if played_monster_card_this_turn:
			player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
			card_being_dragged = null
			return
		
		# Place card in slot
		played_monster_card_this_turn = true
		card_being_dragged.scale = Vector2(CARD_SMALLER_SCALE, CARD_SMALLER_SCALE)
		card_being_dragged.get_node("CardBackImage").z_index = -3
		card_being_dragged.get_node("CardImage").z_index = -2
# Keep text elements visible
		card_being_dragged.get_node("Health").z_index = 1
		card_being_dragged.get_node("Attack").z_index = 1  
		card_being_dragged.get_node("Ability").z_index = 1
		is_hovering_on_card = false
		card_being_dragged.card_slot_card_is_in = card_slot_found
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_slot_found.card_in_slot = true
		card_slot_found.get_node("Area2D/CollisionShape2D").disabled = true
		
		# Add to battlefield only if Monster
		if card_being_dragged.card_type == "Monster":
			$"../BattleManager".player_cards_on_battlefield.append(card_being_dragged)
		else:
			if card_being_dragged.ability_script:
				card_being_dragged.ability_script.trigger_ability($"../BattleManager", card_being_dragged,$"../InPutManager")
			else:
					print("Magic card played but no ability script found")
		
		card_being_dragged = null
		return
			
	player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged = null


func unselect_selected_monster():
	if selected_monster:
		selected_monster.position.y += 20
		selected_monster = null


func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_left_click_released():
	if card_being_dragged:
		finish_drag()


func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)


func on_hovered_off_card(card):
	if !card.defeated:
		# Check if card is NOT in a card slot AND NOT being dragged
		if !card.card_slot_card_is_in && !card_being_dragged:
			# if not dragging
			highlight_card(card, false)
			# Check if hovered off card straight on to another card
			var new_card_hovered = raycast_check_for_card()
			if new_card_hovered:
				highlight_card(new_card_hovered, true)
			else:
				is_hovering_on_card = false


func highlight_card(card, hovered):
	if !card.card_slot_card_is_in:
		if hovered:
			card.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
			card.z_index = 2
		else:
			card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
			card.z_index = 1


func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null


func get_card_with_highest_z_index(cards):
	# Assume the first card in cards array has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	# Loop through the rest of the cards checking for a higher z index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func reset_played_monster():
	played_monster_card_this_turn = false
