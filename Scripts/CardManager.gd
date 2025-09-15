extends Node2D

# Collision masks voor verschillende objecten
const COLLISION_MASK_CARD = 1          # Mask voor kaarten
const COLLISION_MASK_CARD_SLOT = 2     # Mask voor kaart slots

# Verschillende schaalgroottes voor kaarten in verschillende staten
const DEFAULT_CARD_SCALE = 0.8         # Normale grootte van kaarten in hand
const CARD_BIGGER_SCALE = 0.85         # Iets groter bij hover effect
const CARD_SMALLER_SCALE = 0.6         # Kleiner wanneer geplaatst in slot

# Variabelen voor kaart management
var screen_size                        # Schermgrootte voor beweging limiteren
var card_being_dragged                 # Referentie naar kaart die gesleept wordt
var is_hovering_on_card                # Boolean om bij te houden of er gehovered wordt
var player_hand_refence  
var played_monster_card_this_turn = false
			  # Referentie naar PlayerHand script (typo: reference)

func _ready() -> void:
	# Initialisatie bij start
	screen_size = get_viewport_rect().size
	player_hand_refence = $"../PlayerHand"
	# Verbind met InputManager voor mouse release events
	$"../InPutManager".connect("left_mouse_button_released", on_left_click_released)

func _process(delta: float) -> void:
	# Update positie van gesleepte kaart elke frame
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		# Limiteer kaartpositie binnen schermgrenzen
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x, 0, screen_size.x),
			clamp(mouse_pos.y, 0, screen_size.y)
		)

# Alternatieve input handling (uitgecommenteerd)
# Deze methode was vervangen door het InputManager systeem
#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#var card = raycast_check_for_card()
			#if card:
				#start_drag(card)
		#else:
			#if card_being_dragged:
				#finish_drag()

# Start het slepen van een kaart
func start_drag(card):
	card_being_dragged = card
	# Zet kaart op normale grootte tijdens slepen
	card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)

# Beëindig het slepen van een kaart
func finish_drag():
	# Maak kaart iets groter bij release
	card_being_dragged.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
	
	# Check of kaart in een slot gedropt wordt
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		if card_being_dragged.card_type == card_slot_found.card_slot_type:
			# Kaart succesvol in slot geplaatst
			player_hand_refence.remove_card_from_hand(card_being_dragged)
			
			# Configureer kaart voor slot placement
			card_being_dragged.scale = Vector2(CARD_SMALLER_SCALE, CARD_SMALLER_SCALE)
			card_being_dragged.z_index = -1  # Zet achter andere elementen
			is_hovering_on_card = false
			card_being_dragged.card_slot_is_in = card_slot_found  # Markeer als in slot
			card_being_dragged.position = card_slot_found.position
			card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true  # Disable hover
			card_slot_found.card_in_slot = true  # Markeer slot als bezet
			$"../BattleManager".player_cards_on_battlefield.append(card_being_dragged)
			card_being_dragged = null
			return
	player_hand_refence.add_card_to_hand(card_being_dragged, 0.1)
	card_being_dragged = null

# Verbind kaart signalen met deze manager
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

# Callback voor mouse release event van InputManager
func on_left_click_released():
	if card_being_dragged:
		finish_drag()

# Callback wanneer muis over kaart beweegt
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
	highlight_card(card, true)

# Callback wanneer muis van kaart af gaat
func on_hovered_off_card(card):
	# Alleen highlight uitschakelen als kaart niet in slot zit
	if !card.card_slot_is_in:
		if !card_being_dragged:
			highlight_card(card, false)
		
		# Check of er een andere kaart onder de muis is
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

# Highlight/unhighlight een kaart
func highlight_card(card, hovered):
	if hovered:
		# Maak kaart groter en breng naar voren
		card.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
		card.z_index = 2
	else:
		# Reset naar normale grootte en positie
		card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
		card.z_index = 1

# Raycast om card slot te vinden op cursor positie
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

# Raycast om kaart te vinden op cursor positie
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		# Return kaart met hoogste z_index (bovenop andere kaarten)
		return get_card_with_highest_z_index(result)
	return null

# Vindt de kaart met de hoogste z_index uit raycast resultaten
func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	# Loop door alle gevonden kaarten
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	
	return highest_z_card
	
func reset_played_monster():
	played_monster_card_this_turn = false
