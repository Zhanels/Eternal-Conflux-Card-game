# res://Scripts/Ability/Tornado.gd
# Tornado spell ability - deals damage to all enemy cards
extends Node

# Referentie naar de battle manager (wordt ingesteld bij activatie)
var battle_manager

# Constante voor de hoeveelheid schade die tornado doet
const TORNADO_DAMAGE = 1

# Hoofdfunctie die de tornado ability activeert
# Parameters:
# - battle_manger_reference: referentie naar BattleManager voor game state
# - card_with_ability: de tornado kaart die deze ability gebruikt
# - input_manager_reference: referentie naar InputManager om input te blokkeren
func trigger_ability(battle_manger_reference, card_with_ability, input_manager_reference):
	
	# Blokkeer alle speler input tijdens de ability animatie
	input_manager_reference.inputs_disabled = true
	# Schakel de "End Turn" knop uit zodat speler niet per ongeluk beurt kan eindigen
	battle_manger_reference.enable_turn_button(false)
	
	# Wacht 1 seconde voor dramatisch effect
	await battle_manger_reference.wait(1.0)
	
	# Array om kaarten bij te houden die vernietigd moeten worden
	# (We vernietigen ze niet direct om conflicten te voorkomen tijdens iteratie)
	var cards_to_destroy = []
	
	# Loop door alle vijandelijke kaarten op het slagveld
	for card in battle_manger_reference.opponent_cards_on_battlefield:
		# Verminder health met tornado schade (minimum 0)
		card.health = max(0, card.health - TORNADO_DAMAGE)
		# Update de health tekst op de kaart
		card.get_node("Health").text = str(card.health)
		
		# Als kaart nu 0 health heeft, markeer voor vernietiging
		if card.health == 0:
			cards_to_destroy.append(card)
			# Korte pauze tussen elke kaart voor visueel effect
			await battle_manger_reference.wait(1.0)
	
	# Vernietig alle kaarten die 0 health hebben gekregen
	if cards_to_destroy.size() > 0:
		for card in cards_to_destroy:
			battle_manger_reference.destroy_card(card, "Opponent")
	
	# Vernietig de tornado kaart zelf (single-use spell)
	battle_manger_reference.destroy_card(card_with_ability, "Player")
	
	# Finale wachttijd voor smooth overgang
	await battle_manger_reference.wait(1.0)
	
	# Herstel game controls - speler kan weer normaal spelen
	battle_manger_reference.enable_turn_button(true)
	input_manager_reference.inputs_disabled = false
