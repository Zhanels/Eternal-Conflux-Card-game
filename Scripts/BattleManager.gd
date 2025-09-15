extends Node
const SMALL_CARD_SCALE = 0.6
const CARD_MOVE_SPEED = 0.2
const STARTING_HEALTH = 10
const BATTLE_POS_OFFSET = 25

var battle_timer
var empty_monster_card_slots = []
var opponent_cards_on_battlefield = []
var player_cards_on_battlefield = []
var player_health
var opponent_health

func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	empty_monster_card_slots.append($"../CardSlots/OpponentCardslot1")
	empty_monster_card_slots.append($"../CardSlots/OpponentCardslot2")
	empty_monster_card_slots.append($"../CardSlots/OpponentCardslot3")
	empty_monster_card_slots.append($"../CardSlots/OpponentCardslot4")

	player_health = STARTING_HEALTH
	$"../PlayerHealth".text = str(player_health)
	opponent_health = STARTING_HEALTH
	$"../OpponentHealth".text = str(opponent_health)

func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../EndTurnButton".disabled = true
	
	await wait(1.0)
	
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
	
	await wait(1.0)
	
	# Play card if possible
	if empty_monster_card_slots.size() != 0:
		var opponent_hand = $"../OpponentHand".opponent_hand
		if opponent_hand.size() > 0:
			await try_play_card_with_highest_atk()
			await wait(1.0)  # Wait for card placement to complete
	
	# Attack phase - only attack with cards already on battlefield
	if opponent_cards_on_battlefield.size() != 0:
		var enemy_cards_to_attack = opponent_cards_on_battlefield.duplicate()
		for card in enemy_cards_to_attack:
			if player_cards_on_battlefield.size() != 0:
				var card_to_attack = player_cards_on_battlefield.pick_random()
				attack(card, card_to_attack, "Opponent")
			else:
				await direct_attack(card, "Opponent")
	
	end_opponent_turn()
func direct_attack(attacking_card, attacker):
	var new_pos_y
	if attacker == "Opponent":
		new_pos_y = 1080
	else:
		new_pos_y = 0
			
	var new_pos = Vector2(attacking_card.position.x, new_pos_y)
	attacking_card.z_index = 5
	var tween = get_tree().create_tween()
	tween.tween_property(attacking_card, "position", new_pos, CARD_MOVE_SPEED)
	await wait(0.15)


	if attacker == "Opponent":
		player_health = max(0,player_health - attacking_card.attack)
		$"../PlayerHealth".text = str(player_health)
	else:
		opponent_health = max(0,opponent_health - attacking_card.attack)
		$"../OpponentHealth".text = str(opponent_health)
		
		
		
		
		
		
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(attacking_card, "position", attacking_card.card_slot_card_is_in.position, CARD_MOVE_SPEED)
	attacking_card.z_index = 0
	await wait(1.0)
	
	

func attack(attacking_card, defending_card, attacker):
	attacking_card.z_index = 5
	var new_pos = Vector2(defending_card.position.x, defending_card.position.y + BATTLE_POS_OFFSET)
	
	# Move to battle position first
	var tween = get_tree().create_tween()
	tween.tween_property(attacking_card, "position", new_pos, CARD_MOVE_SPEED)
	await tween.finished
	
	# Calculate damage
	defending_card.health = max(0, defending_card.health - attacking_card.attack)
	defending_card.get_node("Health").text = str(defending_card.health)
	
	attacking_card.health = max(0, attacking_card.health - defending_card.attack)
	attacking_card.get_node("Health").text = str(attacking_card.health)
	
	await wait(0.5)
	
	# Then move back to slot
	var tween2 = get_tree().create_tween()
	tween2.tween_property(attacking_card, "position", attacking_card.card_slot_card_is_in.position, CARD_MOVE_SPEED)
	await tween2.finished
	
   
	attacking_card.z_index = 0
	var card_was_destroyed = false
	
	if attacking_card.health == 0:
		destroy_card(attacking_card, attacker)
		card_was_destroyed = true
	if defending_card.health == 0:
		if attacker == "Player":
			destroy_card(defending_card, "Opponent")
		else:
			destroy_card(defending_card, "Opponent")
			card_was_destroyed = true
			
			if card_was_destroyed:
				await wait(1.0)

func destroy_card(card,card_owner):
	var new_pos
	if card_owner	== "Player":
		new_pos = $"../PlayerDiscard".position
	else:
		new_pos = $"../OpponentDiscard".position
	
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_pos, CARD_MOVE_SPEED)

func try_play_card_with_highest_atk():
	var opponent_hand = $"../OpponentHand".opponent_hand
	var random_empty_monster_card_slot = empty_monster_card_slots.pick_random()
	empty_monster_card_slots.erase(random_empty_monster_card_slot)
	
	var card_with_highest_atk = opponent_hand[0]
	for card in opponent_hand:
		if card.attack > card_with_highest_atk.attack:
			card_with_highest_atk = card
	
	var tween = get_tree().create_tween()
	tween.tween_property(card_with_highest_atk, "position", random_empty_monster_card_slot.position, CARD_MOVE_SPEED)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(card_with_highest_atk, "scale", Vector2(SMALL_CARD_SCALE, SMALL_CARD_SCALE), CARD_MOVE_SPEED)
	card_with_highest_atk.get_node("AnimationPlayer").play("Card_Flip")
	
	$"../OpponentHand".remove_card_from_hand(card_with_highest_atk)
	card_with_highest_atk.card_slot_card_is_in = random_empty_monster_card_slot
	opponent_cards_on_battlefield.append(card_with_highest_atk)
#battle_timer.start()
	#await battle_timer.timeout

func end_opponent_turn():
	$"../Deck".reset_draw()
	$"../CardManager".reset_played_monster()
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".disabled = false
