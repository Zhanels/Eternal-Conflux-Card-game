extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2


var player_deck = ["Knight", "Archer", "Demon","Knight", "Archer", "Demon"]
var card_database_reference
var drawn_card_this_turn = false

func _ready() -> void:
	player_deck.shuffle()
	$CardsLeft.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd").new()
	#for i in range()



func draw_card():
	if drawn_card_this_turn:
		return
		drawn_card_this_turn = true
		
		
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$CardsLeft.visible = false
	
	$CardsLeft.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# Gebruik de hele naam, niet de eerste/tweede letter
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name]["attack"])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name]["health"])
	
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("Card_Flip")
