extends Control

func _ready() -> void:
	# Pause the rest of the game
	get_tree().paused = true

	# Make sure this node continues to function while paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_exit_pressed() -> void:
	# Close settings and resume current scene
	get_tree().paused = false
	queue_free()

func _on_exit_game_pressed() -> void:
	# Go back to title screen
	get_tree().paused = false
	get_tree().change_scene_to_file("res://OPEN SCREEN.tscn")

func _on_load_pressed() -> void:
	# Go to load/save screen
	get_tree().paused = false
	get_tree().change_scene_to_file("res://SAVE FILES (LOAD).tscn")

func _on_bgm_value_changed(value: float) -> void:
	var linear = value / 100.0
	var db = -80.0 if linear <= 0.01 else 20.0 * (log(linear) / log(10.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)
