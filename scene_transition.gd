extends Node2D

@onready var animation_intro = $AnimationPlayer

func _ready():
	animation_intro.animation_finished.connect(_on_animation_finished)
	animation_intro.play("EndingCredits")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "EndingCredits":
		get_tree().change_scene_to_file("res://OPEN SCREEN.tscn")
