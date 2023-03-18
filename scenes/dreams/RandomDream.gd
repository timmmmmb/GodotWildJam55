extends Dream

const reveal_distance = 275
var is_revealed = false


func _physics_process(_delta: float) -> void:
	if position.abs().length() < reveal_distance and not self.is_revealed:
		_reveal()


func _reveal():
	if randi() % 2 == 0:
		$ColorRect.color = Color(0.215686, 0.215686, 0.215686)
		self.dream_type = DreamType.BAD
	else:
		$ColorRect.color = Color(0.039216, 0.270588, 0.972549)
		self.dream_type = DreamType.GOOD

	is_revealed = true
