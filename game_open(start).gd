extends Node2D

@onready var animation_intro = $AnimationPlayer


func _ready():
	animation_intro.animation_finished.connect(_on_animation_finished)
	animation_intro.play("COVER ALL")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "COVER ALL":
		get_tree().change_scene_to_file("res://scene_1.tscn")
