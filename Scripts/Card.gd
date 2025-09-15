extends Node2D

# Houdt de originele positie van de kaart bij (gebruikt voor terugkeren naar hand)
var starting_position
var health
var attack
# Boolean die bijhoudt of de kaart in een card slot geplaatst is
var card_slot_is_in

var card_type

# Signalen die uitgezonden worden voor hover effecten
signal hovered        # Wordt uitgezonden wanneer muis over kaart beweegt
signal hovered_off    # Wordt uitgezonden wanneer muis van kaart af gaat

# Called when the node enters the scene tree for the first time.
func _ready():
	# Verbind deze kaart met het signaal systeem van de parent (CardManager)
	# Dit zorgt ervoor dat hover events correct afgehandeld worden
	get_parent().connect_card_signals(self)

# Callback functie die aangeroepen wordt wanneer de muis de Area2D binnenkomt
# Deze functie moet verbonden zijn met het mouse_entered signaal van Area2D
func _on_area_2d_mouse_entered():
	# Zendt het "hovered" signaal uit met deze kaart als parameter
	emit_signal("hovered", self)

# Callback functie die aangeroepen wordt wanneer de muis de Area2D verlaat  
# Deze functie moet verbonden zijn met het mouse_exited signaal van Area2D
func _on_area_2d_mouse_exited():
	# Zendt het "hovered_off" signaal uit met deze kaart als parameter
	emit_signal("hovered_off", self)
