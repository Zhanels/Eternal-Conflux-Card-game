# CardDatabase.gd - Bevat alle kaart data voor het spel

# Dictionary die alle kaart statistieken bevat
# Structuur: "KaartNaam": {"attack": waarde, "health": waarde}
const CARDS = { 
	# Ridder - Sterke verdediging, gemiddelde aanval
	"Knight": {
		"attack": 3,   # Aanvalskracht van de kaart
		"health": 5,   # Levenspunten van de kaart
		"type":"monster"
	},
	
	# Boogschutter - Snelle aanval, lage verdediging  
	"Archer": {
		"attack": 2,   # Lage aanvalskracht
		"health": 3,    # Weinig levenspunten
		"type":"monster"
	},
	
	# Demon - Hoge aanval, gemiddelde verdediging
	"Demon": {
		"attack": 4,   # Hoogste aanvalskracht
		"health": 4,   # Redelijke levenspunten
		"type":"monster"
	}
	}
	
	# Hier kunnen nieuwe kaarten toegevoegd worden:
	# "Wizard": {"attack": 1, "health": 2},
	# "Dragon": {"attack": 6, "health": 8},
	# "Goblin": {"attack": 1, "health": 1}
	
