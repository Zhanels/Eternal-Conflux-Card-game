extends Node2D

# Constanten voor hand layout en animaties
const CARD_WIDTH = 200              # Horizontale afstand tussen kaarten in de hand
const HAND_Y_POSITION = 0         # Vaste Y positie waar de hand wordt weergegeven
const UPDATE_CARD_POS_SPEED = 0.1   # Standaard snelheid voor positie updates

# Variabelen voor hand management
var opponent_hand = []                       # Array met alle kaart objecten in de hand
var card_manager                    # Referentie naar CardManager voor node operaties


func _ready():
	# Verkrijg referentie naar CardManager bij initialisatie
	card_manager = get_parent().get_node("CardManager")

# Voegt een kaart toe aan de hand (nieuw getrokken of terugkerende kaart)
func add_card_to_hand(card, speed_to_move):
	if card not in opponent_hand:
		# Nieuwe kaart uit deck - voeg toe aan begin van hand
		opponent_hand.insert(0, card)
		# Set text color here after card is added
		#card.get_node("Attack").modulate = Color.WHITE
		#card.get_node("Health").modulate = Color.WHITE
		update_hand_positions(speed_to_move)
		
	else:
		# Kaart die terugkeert naar hand - beweeg naar opgeslagen positie
		animate_card_to_position(card, card.starting_position, speed_to_move)

# Update de posities van alle kaarten in de hand
func update_hand_positions(speed):
	for i in range(opponent_hand.size()):
		# Bereken nieuwe positie voor elke kaart gebaseerd op index
		var new_position = calculate_card_position(i)
		var card = opponent_hand[i]
		# Sla nieuwe positie op als starting_position voor toekomstig gebruik
		card.starting_position = new_position
		# Animeer kaart naar nieuwe positie
		animate_card_to_position(card, new_position, speed)

# Berekent de doelpositie voor een kaart gebaseerd op zijn index in de hand
func calculate_card_position(index):
	# Vind het horizontale centrum van het scherm
	var center_screen_x = get_viewport().size.x / 2
	# Bereken totale breedte die de hand in beslag neemt
	var total_width = (opponent_hand.size() - 1) * CARD_WIDTH
	# Bereken X offset voor deze specifieke kaart
	var x_offset = center_screen_x - index * CARD_WIDTH + total_width / 2
	return Vector2(x_offset, HAND_Y_POSITION)

# Animeert een kaart naar een doelpositie met een tween
func animate_card_to_position(card, new_position, speed_to_move):
	var tween = get_tree().create_tween()
	# Tween de positie eigenschap van de kaart
	tween.tween_property(card, "position", new_position, speed_to_move)

# Verwijdert een kaart uit de hand en update posities van overige kaarten
func remove_card_from_hand(card_name):
	# PROBLEEM: Deze functie heeft een bug!
	# Het probeert een kaart te vinden via card_manager.get_node() 
	# maar zou direct de kaart parameter moeten gebruiken
	var card = card_manager.get_node(str(card_name))
	if card in opponent_hand:
		opponent_hand.erase(card)
		# Update posities van overgebleven kaarten
		update_hand_positions(UPDATE_CARD_POS_SPEED)
