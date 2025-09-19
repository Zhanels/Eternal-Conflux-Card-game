# res://Scripts/Ability/AttackTwice.gd
# Tornado spell ability - deals damage to all enemy cards
extends Node

const ABILITY_TRIGGER_EVENT = "after_attack"
# Referentie naar de battle manager (wordt ingesteld bij activatie)
var battle_manager
var already_activated = false


# Constante voor de hoeveelheid schade die tornado doet


# Hoofdfunctie die de tornado ability activeert
# Parameters:
# - battle_manger_reference: referentie naar BattleManager voor game state
# - card_with_ability: de tornado kaart die deze ability gebruikt
# - input_manager_reference: referentie naar InputManager om input te blokkeren

func trigger_ability(battle_manger_reference, card_with_ability, input_manager_reference, trigger_event):
	
	if ABILITY_TRIGGER_EVENT != trigger_event:
		return
	
	if already_activated:
		return
	
	if card_with_ability in battle_manger_reference.player_cards_that_attacked_this_turn:
		battle_manger_reference.player_cards_that_attacked_this_turn.erase(card_with_ability)
		already_activated = true
		
func end_turn_reset():
	print("test end reset")
	already_activated = false
