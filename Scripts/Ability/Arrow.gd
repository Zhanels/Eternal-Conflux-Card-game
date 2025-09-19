# res://Scripts/Ability/Tornado.gd
# Tornado spell ability - deals damage to all enemy cards
extends Node

# Referentie naar de battle manager (wordt ingesteld bij activatie)
var battle_manager

# Constante voor de hoeveelheid schade die tornado doet
const ARROW_DAMAGE = 1
const ABILITY_TRIGGER_EVENT = "card_placed"
# Hoofdfunctie die de tornado ability activeert
# Parameters:
# - battle_manger_reference: referentie naar BattleManager voor game state
# - card_with_ability: de tornado kaart die deze ability gebruikt
# - input_manager_reference: referentie naar InputManager om input te blokkeren
func trigger_ability(battle_manger_reference, card_with_ability, input_manager_reference, trigger_event):
	
	if ABILITY_TRIGGER_EVENT != trigger_event:
		return
	
	# Blokkeer alle speler input tijdens de ability animatie
	input_manager_reference.inputs_disabled = true
	# Schakel de "End Turn" knop uit zodat speler niet per ongeluk beurt kan eindigen
	battle_manger_reference.enable_turn_button(false)
	
	# Array om kaarten bij te houden die vernietigd moeten worden
	# (We vernietigen ze niet direct om conflicten te voorkomen tijdens iteratie)

	# Finale wachttijd voor smooth overgang
	await battle_manger_reference.wait(1.0)
	
	battle_manger_reference.direct_damage(ARROW_DAMAGE)
	
	await battle_manger_reference.wait(1.0)
	
	# Herstel game controls - speler kan weer normaal spelen
	battle_manger_reference.enable_turn_button(true)
	input_manager_reference.inputs_disabled = false
	
# Add this to your Arrow.gd script
func end_turn_reset():
	# Arrow ability doesn't need end turn reset, so this function does nothing
	pass
		
