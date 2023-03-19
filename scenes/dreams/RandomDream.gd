extends Dream

const reveal_distance = 275
var is_revealed = false


func _physics_process(_delta: float) -> void:
	if position.abs().length() < reveal_distance and not self.is_revealed:
		_reveal()


func _reveal():
	if randi() % 2 == 0:
		self.dream_type = DreamType.BAD
		$CanvasModulate.color = "4f5263"
	else:
		self.dream_type = DreamType.GOOD
		$CanvasModulate.color = "d66ce8"

	is_revealed = true
	_set_dream_texture()
