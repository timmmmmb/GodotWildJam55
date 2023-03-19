extends Label


func _ready() -> void:
	visible = false


func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		get_tree().paused = false
