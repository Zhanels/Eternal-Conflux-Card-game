# CardDatabase.gd - Bevat alle kaart data voor het spel

# Dictionary die alle kaart statistieken bevat
# Structuur: "KaartNaam": {"attack": waarde, "health": waarde}
const CARDS = { 
	# Ridder - Sterke verdediging, gemiddelde aanval
	"Knight": {
		"attack": 3,   # Aanvalskracht van de kaart
		"health": 3,   # Levenspunten van de kaart
		"type":"Monster",
		"Ability": null,
		"script_path": null
		
	},
	
	# Boogschutter - Snelle aanval, lage verdediging  
	"Archer": {
		"attack": 2,   # Lage aanvalskracht
		"health": 1,    # Weinig levenspunten
		"type":"Monster",
		"Ability": null,
		"script_path": null
	},
	
	# Demon - Hoge aanval, gemiddelde verdediging
	"Demon": {
		"attack": 4,   # Hoogste aanvalskracht
		"health": 4,   # Redelijke levenspunten
		"type":"Monster",
		"Ability": null,
		"script_path": null
	},
	"Tornado": {
	"attack": null,
	"health": null,
	"type": "Magic",
	"Ability": "Deal 1 magic damage to ALL ENEMY'S",
	"script_path": "res://Scripts/Ability/Tornado.gd"
}
	}
	
	# Hier kunnen nieuwe kaarten toegevoegd worden:
	# "Wizard": {"attack": 1, "health": 2},
	# "Dragon": {"attack": 6, "health": 8},
	# "Goblin": {"attack": 1, "health": 1}
	
