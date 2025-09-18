extends Node2D

# Signalen die uitgezonden worden voor mouse events
signal left_mouse_button_clicked     # Wordt uitgezonden bij mouse press
signal left_mouse_button_released    # Wordt uitgezonden bij mouse release

# Referenties naar andere managers voor directe communicatie
var card_manager_reference           # Referentie naar CardManager node
var deck_reference                   # Referentie naar Deck node
var inputs_disabled = false	

func _ready() -> void:
	# Initialiseer referenties naar sibling nodes
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"

# Collision masks voor verschillende objecttypen
const COLLISION_MASK_CARD = 1        # Mask voor kaarten
const COLLISION_MASK_DECK = 4        # Mask voor het deck
const COLLISION_MASK_OPPONENT_DECK = 8

# Hoofdinput handler - behandelt alle mouse input voor het spel
func _input(event):
	# Check of het een linker muisklik is
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Mouse button ingedrukt
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()  # Check wat er geklikt werd
		else:
			# Mouse button losgelaten
			emit_signal("left_mouse_button_released")

# Raycast functie om te detecteren wat er geklikt werd
func raycast_at_cursor():
	if inputs_disabled:
		return
	# Setup voor physics raycast
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	# Geen specifieke collision_mask hier - detecteert alles
	
## Voer raycast uit
	#var results = space_state.intersect_point(parameters)
	#print("=== RAYCAST DEBUG ===")
	#print("Mouse position: ", get_global_mouse_position())
	#print("Results found: ", results.size())
	#
	#if results.size() > 0:
		## Er is iets gevonden onder de cursor
		#print("Found object: ", results[0].collider.get_parent().name)
		#var result_collision_mask = results[0].collider.collision_mask
		#print("Collision mask found: ", result_collision_mask)
		#print("COLLISION_MASK_DECK = ", COLLISION_MASK_DECK)
		#print("COLLISION_MASK_CARD = ", COLLISION_MASK_CARD)
		#print("COLLISION_MASK_OPPONENT_DECK = ", COLLISION_MASK_OPPONENT_DECK)
		#
		#if result_collision_mask == COLLISION_MASK_DECK:
			## Deck werd geklikt - trek een kaart
			#print("Deck clicked - drawing card")
			#get_parent().get_node("Deck").draw_card()
			#
		#elif result_collision_mask == COLLISION_MASK_CARD:
			## Kaart werd geklikt - start drag operatie
			#print("Card clicked - processing...")
			#var card_found = results[0].collider.get_parent()
			#print("Card found: ", card_found.name if card_found else "null")
			#if card_found:
				#print("Calling card_manager_reference.card_clicked")
				#card_manager_reference.card_clicked(card_found)
			#elif result_collision_mask == COLLISION_MASK_DECK:
				#print("Secondary deck check triggered")
				#deck_reference.draw_card()
			#elif result_collision_mask == COLLISION_MASK_OPPONENT_DECK:
				#print("Opponent deck check triggered")
				#$"../BattleManager".opponent_card_selected(results[0].collider.get_parent())
		#else:
			#print("Unknown collision mask: ", result_collision_mask)
	#else:
		#print("No results found at cursor position")
		
		
		
# Voer raycast uit
	var results = space_state.intersect_point(parameters)
	print("=== RAYCAST DEBUG ===")
	print("Mouse position: ", get_global_mouse_position())
	print("Results found: ", results.size())
	
	if results.size() > 0:
		# Er is iets gevonden onder de cursor
		print("Found object: ", results[0].collider.get_parent().name)
		var result_collision_mask = results[0].collider.collision_mask
		print("Collision mask found: ", result_collision_mask)
		
		if result_collision_mask == COLLISION_MASK_DECK:
			# Deck werd geklikt - trek een kaart
			print("Deck clicked - drawing card")
			get_parent().get_node("Deck").draw_card()
			
		elif result_collision_mask == COLLISION_MASK_CARD:
			# Player kaart werd geklikt
			print("Player card clicked - processing...")
			var card_found = results[0].collider.get_parent()
			print("Card found: ", card_found.name if card_found else "null")
			if card_found:
				print("Calling card_manager_reference.card_clicked")
				card_manager_reference.card_clicked(card_found)
				
		elif result_collision_mask == COLLISION_MASK_OPPONENT_DECK:
			# Opponent kaart werd geklikt
			print("Opponent card clicked - processing...")
			var opponent_card_found = results[0].collider.get_parent()
			print("Opponent card found: ", opponent_card_found.name if opponent_card_found else "null")
			if opponent_card_found:
				print("Calling card_manager_reference.card_clicked for opponent card")
				card_manager_reference.card_clicked(opponent_card_found)
		else:
			print("Unknown collision mask: ", result_collision_mask)
	else:
		print("No results found at cursor position")
