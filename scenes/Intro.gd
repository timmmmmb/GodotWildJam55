extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("Intro")


func _input(event):
	if not event.is_action_pressed("ui_accept"):
		return
	
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation_position < 7.5:
		$AnimationPlayer.advance(10.0)
	else:
		get_tree().change_scene("res://scenes/Level.tscn")
