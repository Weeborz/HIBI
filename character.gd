extends Node2D

@onready var sprite = $Sprite2D

const CHARACTER_EXPRESSIONS = {
	"Alice": {
		"neutral": preload("res://ASSETS/CHARACTERS/ALICE/Final/Neutral.png"),
		"angry": preload("res://ASSETS/CHARACTERS/ALICE/Final/Angry.png"),
		"happy": preload("res://ASSETS/CHARACTERS/ALICE/Final/happy.png"),
		"sad": preload("res://ASSETS/CHARACTERS/ALICE/Final/sadCrying.png"),
		"shocked": preload("res://ASSETS/CHARACTERS/ALICE/Final/SadShocked.png"),
	},
	"Mother": {
		"sad": preload("res://ASSETS/CHARACTERS/MOTHER/Final/Sad.png"),
		"neutral": preload("res://ASSETS/CHARACTERS/MOTHER/Final/Neutral.png"),
		"angry": preload("res://ASSETS/CHARACTERS/MOTHER/Final/Angry.png"),
		"crying": preload("res://ASSETS/CHARACTERS/MOTHER/Final/Devastated.png"),
		"happy": preload("res://ASSETS/CHARACTERS/MOTHER/Final/Happy.png"),
		"VAngry": preload("res://ASSETS/CHARACTERS/MOTHER/Final/VeryAngry.png"),
	},
	"Rosa": {
		"angry": preload("res://ASSETS/CHARACTERS/ROSA/Final/Angry.png"),
		"agitated": preload("res://ASSETS/CHARACTERS/ROSA/Final/Agitated.png"),
		"devastated": preload("res://ASSETS/CHARACTERS/ROSA/Final/Devastated.png"),
		"neutral": preload("res://ASSETS/CHARACTERS/ROSA/Final/Neutral.png"),
		"sad": preload("res://ASSETS/CHARACTERS/ROSA/Final/Sad.png"),
	},
	"Rosa Mind": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
	"Heinz": {
		"angry": preload("res://ASSETS/CHARACTERS/HEINZ (Ketchup)/Final/angry.png"),
		"smile": preload("res://ASSETS/CHARACTERS/HEINZ (Ketchup)/Final/happy.png"),
		"neutral": preload("res://ASSETS/CHARACTERS/HEINZ (Ketchup)/Final/neutral.png"),
		"sad": preload("res://ASSETS/CHARACTERS/HEINZ (Ketchup)/Final/sad.png"),
		"aback": preload("res://ASSETS/CHARACTERS/HEINZ (Ketchup)/Final/aback.png"),
	},
	"Father": {
		"angryNormal": preload("res://ASSETS/CHARACTERS/FATHER/Final/AngryNormal.png"),
		"neutral": preload("res://ASSETS/CHARACTERS/FATHER/Final/Neutral.png"),
		"shocked": preload("res://ASSETS/CHARACTERS/FATHER/Final/ShockedObedient.png"),
		"agitated": preload("res://ASSETS/CHARACTERS/FATHER/Final/AngryAgitated.png"),
	},
	"Clarence": {
		"angry": preload("res://ASSETS/CHARACTERS/CLARENCE/Final/Angry.png"),
		"neutral": preload("res://ASSETS/CHARACTERS/CLARENCE/Final/Neutral.png"),
		"sad": preload("res://ASSETS/CHARACTERS/CLARENCE/Final/Sad.png"),
		"smile": preload("res://ASSETS/CHARACTERS/CLARENCE/Final/Happy.png"),
		"sad2": preload("res://ASSETS/CHARACTERS/CLARENCE/Final/Sympathy.png"),
	},
	"Alice Mind": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
	"Clarence Mind": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
	" ": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
	"?": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
	"???": {
		"neutral": preload("res://ASSETS/CHARACTERS/transparent.jpg"),
	},
}

func _ready():
	for child in get_children():
		if child is Sprite2D:
			child.visible = false

	# Called when the node enters the scene tree for the first time.
func change_character(character: String, expression: String = "neutral"):
	# Hide all character sprites
	for child in get_children():
		if child is Sprite2D:
			child.visible = false

	# Show only the relevant character
	if has_node(character):
		var char_node = get_node(character) as Sprite2D
		if CHARACTER_EXPRESSIONS.has(character) and CHARACTER_EXPRESSIONS[character].has(expression):
			char_node.texture = CHARACTER_EXPRESSIONS[character][expression]
			char_node.visible = true
		else:
			printerr("Expression not found for character: ", character, " / ", expression)
	else:
		printerr("Character node not found: ", character)
