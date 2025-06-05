extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://OPEN SCREEN.tscn")


func _on_bgm_value_changed(value: float) -> void:
	var linear = value / 100.0
	var db = -80.0 if linear <= 0.01 else 20.0 * (log(linear) / log(10.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func _on_exit_pressed():
	queue_free()  # This removes the overlay but keeps the main menu & BGM alive
