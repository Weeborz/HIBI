extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuBGM.play()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://GAME OPEN(START).tscn")

func _on_load_pressed() -> void:
	get_tree().change_scene_to_file("res://SAVE FILES (LOAD).tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://SETTINGS.tscn")


func _on_exit_game_pressed() -> void:
	get_tree().quit()
