extends TextureRect

@onready var dialogue_text = $DialogueText
@onready var next_button = $NextButton

var dialogue_lines: Array = []
var current_index: int = 0

func _ready():
	call_deferred("_connect_button")

func _connect_button():
	next_button.pressed.connect(_on_next_pressed)
	visible = false

func start_dialogue(lines: Array):
	dialogue_lines = lines
	current_index = 0
	visible = true
	show_line()

func show_line():
	if current_index < dialogue_lines.size():
		dialogue_text.text = dialogue_lines[current_index]
	else:
		hide()

func _on_next_pressed():
	current_index += 1
	show_line()
