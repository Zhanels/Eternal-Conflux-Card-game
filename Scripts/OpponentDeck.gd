extends Node2D

# Pad naar de kaart scene die geïnstantieerd wordt
const CARD_SCENE_PATH = "res://Scenes/OpponentCard.tscn"
# Snelheid waarmee kaarten naar de hand bewegen na trekken
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 5

# Array met alle kaarten in het deck (duplicaten mogelijk)
var opponent_deck = ["Knight", "Archer", "Demon","Knight", "Archer", "Demon","Archer","Archer","Archer","Archer","Archer"]
# Referentie naar de kaart database voor stats
var card_database_reference
# Boolean om te voorkomen dat meerdere kaarten per beurt getrokken worden


func _ready() -> void:
	# Schud het deck bij start van het spel
	opponent_deck.shuffle()
	# Update UI met aantal kaarten in deck
	$CardsLeft.text = str(opponent_deck.size())
	# Laad de kaart database voor attack/health waarden
	card_database_reference = preload("res://Scripts/CardDatabase.gd").new()
	for i in range(STARTING_HAND_SIZE):
		draw_card()
	
	

# Functie om een kaart te trekken uit het deck
func draw_card():
	
	# Check of er al een kaart getrokken is deze beurt

	# PROBLEEM: Deze regel staat verkeerd geplaatst!
	# drawn_card_this_turn = true zou VOOR de return moeten staan
	
	
	# Trek de eerste kaart uit het deck
	var card_drawn_name = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)
	
	# Als deck leeg is, verberg deck visueel
	if opponent_deck.size() == 0:
		
		$Sprite2D.visible = false                  # Verberg deck sprite
		$CardsLeft.visible = false                 # Verberg counter
	
	# Update kaarten counter in UI
	$CardsLeft.text = str(opponent_deck.size())
	
	# Instantieer nieuwe kaart
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	# Laad de juiste afbeelding voor de kaart
	var card_image_path = str("res://Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# Zet attack en health waarden uit database
	new_card.health = card_database_reference.CARDS[card_drawn_name]["health"]
	new_card.attack = card_database_reference.CARDS[card_drawn_name]["attack"]
	new_card.get_node("Attack").text = str(new_card.attack)
	new_card.get_node("Health").text = str(new_card.health)
	new_card.card_type = card_database_reference.CARDS[card_drawn_name]["type"]
	# Voeg kaart toe aan scene via CardManager
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	
	# Voeg kaart toe aan speler's hand met animatie
	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	
	
