Godot Card Game
Een 2D kaartspel gebouwd in Godot Engine met drag-and-drop functionaliteit en hand management.
Features

Drag & Drop Kaarten: Kaarten kunnen worden opgepakt en verplaatst
Hand Management: Automatische positionering van kaarten in de hand
Deck Systeem: Trek kaarten uit een deck
Card Slots: Plaats kaarten in specifieke slots
Hover Effecten: Visuele feedback bij hover over kaarten
Animaties: Smooth tweening voor kaartbewegingen

Project Structuur
├── Scenes/
│   ├── Main.tscn          # Hoofd scene
│   ├── Card.tscn          # Kaart prefab
│   └── CardSlot.tscn      # Kaart slot prefab
├── Scripts/
│   ├── CardManager.gd     # Beheer van kaart interacties
│   ├── InputManager.gd    # Input handling
│   ├── PlayerHand.gd      # Hand management
│   ├── Deck.gd           # Deck functionaliteit
│   └── CardDatabase.gd    # Kaart data
└── Assets/
    ├── Knight.png
    ├── Archer.png
    └── Demon.png
Scripts Overzicht
CardManager.gd
Hoofdscript voor kaart interacties:

Drag & drop functionaliteit
Collision detection
Kaart highlighting
Communicatie tussen verschillende systemen

InputManager.gd
Behandelt alle input events:

Muis clicks
Raycast detection voor kaarten en deck
Signaal distributie

PlayerHand.gd
Beheert de spelershand:

Kaart positionering in hand
Animaties voor kaartbewegingen
Hand update bij toevoegen/verwijderen kaarten

Deck.gd
Deck functionaliteit:

Kaarten trekken uit deck
Kaart instantiatie
Deck UI updates

Collision Layers
Het project gebruikt verschillende collision masks:

COLLISION_MASK_CARD = 1 - Voor kaarten
COLLISION_MASK_CARD_SLOT = 2 - Voor kaart slots
COLLISION_MASK_DECK = 4 - Voor het deck

Gebruik
Kaarten Spelen

Klik op het deck om een kaart te trekken
Hover over kaarten voor highlight effect
Sleep kaarten naar card slots om ze te spelen
Kaarten keren terug naar hand als ze niet in een slot worden geplaatst

Belangrijke Constanten
gdscriptconst CARD_WIDTH = 200              # Breedte tussen kaarten in hand
const HAND_Y_POSITION = 890         # Y positie van de hand
const UPDATE_CARD_POS_SPEED = 0.1   # Animatie snelheid
Vereisten

Godot 4.x
Sprites voor kaarten (Knight.png, Archer.png, Demon.png)

Installatie

Clone de repository
Open het project in Godot
Zorg ervoor dat alle asset files in de juiste mappen staan
Run de Main scene

Bekende Issues

Kaarten hebben een starting_position property nodig in Card.gd
CardDatabase.gd moet de juiste structuur hebben voor kaart stats
Collision shapes moeten correct geconfigureerd zijn voor Area2D nodes

Toekomstige Features

 Meer kaart types
 Spelregels implementatie
 Multiplayer support
 Sound effects
 Particle effects voor kaart acties

Licentie
Dit project is gemaakt voor educatieve doeleinden.
