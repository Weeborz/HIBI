extends Node2D

@onready var dialog_ui = %DialogueUI
@onready var background = $TextureRect
@onready var character_scene = %Character
@onready var bgm_player = $BGMPlayer

var dialog_index : int = 0
var dialogue_lines : Array = []
var current_bgm : String = ""
var fade_duration := 1.0  # seconds

const BACKGROUNDS = {
	"garden": preload("res://ASSETS/BACKGROUND/resized/garden fullview.png"),
	"mansion": preload("res://ASSETS/BACKGROUND/resized/mansion.png"),
	"aliceroom": preload("res://ASSETS/BACKGROUND/resized/bedroom.png"),
	"attic": preload("res://ASSETS/BACKGROUND/resized/attic.png"),
	"basement": preload("res://ASSETS/BACKGROUND/resized/basement.png"),
	"bathroomdoorhallway": preload("res://ASSETS/BACKGROUND/resized/bathroomhallway.png"),
	"hallway": preload("res://ASSETS/BACKGROUND/resized/Hallway (2).png"),
	"keyholebathroom": preload("res://ASSETS/BACKGROUND/resized/doorknob.png"),
	"kitchen": preload("res://ASSETS/BACKGROUND/resized/kitchen.png"),
	"livingroom": preload("res://ASSETS/BACKGROUND/resized/livingroom.png"),
	"nightsky": preload("res://ASSETS/BACKGROUND/resized/nightsky.png"),
	"stairs": preload("res://ASSETS/BACKGROUND/resized/stairs.png"),
	"blackscreen": preload("res://ASSETS/BACKGROUND/Black Screen.png"),
	"sky": preload("res://ASSETS/BACKGROUND/resized/daytime sky.png"),
	"gardenzoom": preload("res://ASSETS/BACKGROUND/resized/gardenzoom.png"),
	"town": preload("res://ASSETS/BACKGROUND/resized/town.png"),
	"hilltop": preload("res://ASSETS/BACKGROUND/resized/mansion hilltop.png"),
}

const BGM = {
	"Rosatheme": preload("res://ASSETS/BGM/Rosas-tango.mp3"),
	"RosaAbuse": preload("res://ASSETS/BGM/RosaAbusiveScenes.mp3"),
	"lighthearted": preload("res://ASSETS/BGM/LightHeartedScenes.mp3"),
	"heavyhearted": preload("res://ASSETS/BGM/HeavyHeartedScenes.mp3"),
	"ending": preload("res://ASSETS/BGM/EndingScene.mp3"),
	"acceptance": preload("res://ASSETS/BGM/Acceptance.mp3"),
	"Silent": null
}

func _ready() -> void:
	dialogue_lines = load_dialog("res://script/STORY.json")
	dialog_ui.choice_selected.connect(_on_choice_selected)
	dialog_ui.animation_done.connect(_on_animation_done)
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_index = 0
	process_current_line()

func _input(event) -> void:
	if has_node("SettingsOverlay"):
		return

	var line = dialogue_lines[dialog_index]
	var has_choices = line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialogue_lines) - 1:
				dialog_index += 1
				process_current_line()
			else:
				await get_tree().create_timer(2.5).timeout
				get_tree().change_scene_to_file("res://SCENE TRANSITION.tscn")

func process_current_line():
	var line = dialogue_lines[dialog_index]

	if line.has("goto"):
		dialog_index = get_anchor_position(line["goto"])
		process_current_line()
		return

	if line.has("anchor"):
		dialog_index += 1
		process_current_line()
		return

	if line.has("choices"):
		dialog_ui.display_choices(line["choices"])
	else:
		dialog_ui.change_line(line["speaker"], line["text"])

	if line.has("expression"):
		character_scene.change_character(line["speaker"], line["expression"])

	if line.has("background") and BACKGROUNDS.has(line["background"]):
		change_background(line["background"])

	if line.has("bgm") and BGM.has(line["bgm"]):
		fade_to_bgm(line["bgm"])

func fade_to_bgm(name: String):
	if current_bgm == name:
		return
	current_bgm = name
	var new_stream = BGM.get(name, null)
	await fade_out_bgm()
	bgm_player.stream = new_stream
	if new_stream != null:
		bgm_player.volume_db = -80
		bgm_player.play()
		await fade_in_bgm()

func fade_out_bgm():
	var steps = 10
	var step_time = fade_duration / steps
	for i in range(steps):
		bgm_player.volume_db = lerp(0.0, -80.0, float(i) / steps)
		await get_tree().create_timer(step_time).timeout
	bgm_player.stop()

func fade_in_bgm():
	var steps = 10
	var step_time = fade_duration / steps
	for i in range(steps):
		bgm_player.volume_db = lerp(-80.0, 0.0, float(i) / steps)
		await get_tree().create_timer(step_time).timeout

func _on_animation_done():
	pass

func get_anchor_position(anchor: String):
	for i in range(dialogue_lines.size()):
		if dialogue_lines[i].has("anchor") and dialogue_lines[i]["anchor"] == anchor:
			return i
	printerr("ERROR: Could Not Find Anchor '" + anchor + "'")
	return null

func load_dialog(file_path):
	if not FileAccess.file_exists(file_path):
		printerr("ERROR: File Does Not Exist", file_path)
		return null

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("ERROR: Failed To Open File", file_path)
		return null

	var content = file.get_as_text()
	var json_content = JSON.parse_string(content)

	if json_content == null:
		printerr("ERROR: Failed To Parse JSON From File", file_path)
		return null

	return json_content

func _on_choice_selected(anchor: String):
	dialog_index = get_anchor_position(anchor)
	process_current_line()

func change_background(name: String):
	if BACKGROUNDS.has(name):
		background.texture = BACKGROUNDS[name]
	else:
		printerr("Background not found: ", name)

func _on_texture_button_pressed() -> void:
	var settings_scene = preload("res://script/SettingsInGame.tscn").instantiate()
	$ForButton.add_child(settings_scene)
	settings_scene.set_name("SettingsOverlay")
	get_tree().paused = true
