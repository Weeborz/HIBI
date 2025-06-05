extends Control

signal animation_done
signal choice_selected

#preload player choice scene
const ChoiceButtonScene = preload("res://script/button.tscn")
const ANIMATION_SPEED : int = 30
var animate_text : bool = false
var current_visible_characters : int = 0

@onready var dialogue_line = %DialogueLine
@onready var speaker_name = %SpeakerName
@onready var choice_list = %ChoicesContainer

func _ready():
	#hide the choice list
	choice_list.hide()

func _process(delta):
	if animate_text:
		if dialogue_line.visible_ratio < 1:
			dialogue_line.visible_ratio += (1.0/dialogue_line.text.length()) * (ANIMATION_SPEED * delta)
			current_visible_characters = dialogue_line.visible_characters
		else:
			animate_text = false
			animation_done.emit()

func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialogue_line.text = line
	dialogue_line.visible_characters = 0
	animate_text = true
	
func skip_text_animation():
	dialogue_line.visible_ratio = 1
	
func display_choices(choices: Array):
	#clear any existing choices first
	for child in choice_list.get_children():
		child.queue_free()
	
	#create a new button for each choice
	for choice in choices: 
		var choice_button = ChoiceButtonScene.instantiate()
		choice_button.text = choice["text"]
		#attach signal to button
		choice_button.pressed.connect(_on_choice_button_pressed.bind(choice["goto"]))
		
		#add the button to the choices container
		choice_list.add_child(choice_button)
		
	#show the choice list
	choice_list.show()
	
func _on_choice_button_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_list.hide()
	
	
	
	
	
	
	
