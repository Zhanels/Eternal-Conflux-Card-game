extends Node2D

# Signalen die uitgezonden worden voor mouse events
signal left_mouse_button_clicked     # Wordt uitgezonden bij mouse press
signal left_mouse_button_released    # Wordt uitgezonden bij mouse release

# Referenties naar andere managers voor directe communicatie
var card_manager_reference           # Referentie naar CardManager node
var deck_reference                   # Referentie naar Deck node

func _ready() -> void:
	# Initialiseer referenties naar sibling nodes
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"

# Collision masks voor verschillende objecttypen
const COLLISION_MASK_CARD = 1        # Mask voor kaarten
const COLLISION_MASK_DECK = 4        # Mask voor het deck

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
	# Setup voor physics raycast
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	# Geen specifieke collision_mask hier - detecteert alles
	
	# Voer raycast uit
	var results = space_state.intersect_point(parameters)
	if results.size() > 0:
		# Er is iets gevonden onder de cursor
		var result_collision_mask = results[0].collider.collision_mask
		
		if result_collision_mask == COLLISION_MASK_DECK:
			# Deck werd geklikt - trek een kaart
			get_parent().get_node("Deck").draw_card()
			
		elif result_collision_mask == COLLISION_MASK_CARD:
			# Kaart werd geklikt - start drag operatie
			var card_found = results[0].collider.get_parent()
			if card_found:
				# Gebruik referentie voor betere performance (uitgecommenteerde regel is alternatief)
				#get_parent().get_node("CardManager").start_drag(card_found)
				card_manager_reference.card_clicked(card_found)
			elif result_collision_mask == COLLISION_MASK_DECK:
				deck_reference.draw_card()
