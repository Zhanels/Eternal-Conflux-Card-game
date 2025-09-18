extends Node2D

# Pad naar de kaart scene die geïnstantieerd wordt
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
# Snelheid waarmee kaarten naar de hand bewegen na trekken
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 5

# Array met alle kaarten in het deck (duplicaten mogelijk)
var player_deck =  ["Knight", "Archer", "Demon", "Knight", "Tornado"]
# Referentie naar de kaart database voor stats
var card_database_reference
# Boolean om te voorkomen dat meerdere kaarten per beurt getrokken worden
var drawn_card_this_turn = false

func _ready() -> void:
	# Schud het deck bij start van het spel
	player_deck.shuffle()
	# Update UI met aantal kaarten in deck
	$CardsLeft.text = str(player_deck.size())
	# Laad de kaart database voor attack/health waarden
	card_database_reference = preload("res://Scripts/CardDatabase.gd").new()
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false
	

# Functie om een kaart te trekken uit het deck
func draw_card():
	# Check of er al een kaart getrokken is deze beurt
	if drawn_card_this_turn:
		return  # Stop hier als al getrokken
	
	# PROBLEEM: Deze regel staat verkeerd geplaatst!
	# drawn_card_this_turn = true zou VOOR de return moeten staan
	drawn_card_this_turn = true
	
	# Trek de eerste kaart uit het deck
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	# Als deck leeg is, verberg deck visueel
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true  # Disable clicking
		$Sprite2D.visible = false                  # Verberg deck sprite
		$CardsLeft.visible = false                 # Verberg counter
	
	# Update kaarten counter in UI
	$CardsLeft.text = str(player_deck.size())
	
	# Instantieer nieuwe kaart
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	# Laad de juiste afbeelding voor de kaart
	var card_image_path = str("res://Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	new_card.card_type = card_database_reference.CARDS[card_drawn_name]["type"]
	if new_card.card_type == "Magic":
	# Load ability script as a separate object, don't replace the card's script
		var script_path = card_database_reference.CARDS[card_drawn_name]["script_path"]
		if script_path:
			var ability_script_class = load(script_path)
			new_card.ability_script = ability_script_class.new()
		# Pass reference to battle manager or other needed objects
			new_card.ability_script.battle_manager = get_parent().get_node("BattleManager")
		
	if new_card.card_type == "Monster":
		new_card.get_node("Ability").visible = false
	# Set attack and health values from database
		new_card.health = card_database_reference.CARDS[card_drawn_name]["health"]
		new_card.attack = card_database_reference.CARDS[card_drawn_name]["attack"]
		new_card.get_node("Attack").text = str(new_card.attack)
		new_card.get_node("Health").text = str(new_card.health)
	else:
		new_card.get_node("Attack").visible = false
		new_card.get_node("Health").visible = false
		new_card.get_node("Ability").text = card_database_reference.CARDS[card_drawn_name]["Ability"]
	# Voeg kaart toe aan scene via CardManager
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	
	# Voeg kaart toe aan speler's hand met animatie
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	
	# Speel kaart flip animatie af
	new_card.get_node("AnimationPlayer").play("Card_Flip")
	
func reset_draw():
	drawn_card_this_turn = false
