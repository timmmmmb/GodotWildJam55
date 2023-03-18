extends Node2D

signal victory
signal defeat

const spawn_radius = 675

var GoodDream = preload("res://scenes/dreams/GoodDream.tscn")
var BadDream = preload("res://scenes/dreams/BadDream.tscn")
var FastDream = preload("res://scenes/dreams/FastDream.tscn")
var RandomDream = preload("res://scenes/dreams/RandomDream.tscn")
var SpiralDream = preload("res://scenes/dreams/SpiralDream.tscn")

var lives = 3

var phases = [
	{
		"spawn_interval": 2.5,
		"dreams": [
			{"scene": BadDream, "probability": 1}
		]
	},
	{
		"spawn_interval": 2.2,
		"dreams":
		[
			{"scene": BadDream, "probability": 0.75},
			{"scene": GoodDream, "probability": 0.25}
		]
	}
]

var current_phase_index = 0
var current_phase = phases[0]


func _on_SpawnTimer_timeout() -> void:
	_spawn_dream()


func _spawn_dream():
	var dream = _randomly_select_dream().instance()
	dream.position = Vector2(spawn_radius, 0).rotated(randf() * TAU)
	dream.connect("loose_life", self, "_loose_life")
	add_child(dream)
	


func _randomly_select_dream() -> Resource:
	var dreams = self.current_phase.dreams
	var random_value = randf()

	for dream in dreams:
		if dream.probability >= random_value:
			return dream.scene

		random_value -= dream.probability

	return GoodDream


func _loose_life():
	if self.lives == 1:
		emit_signal("defeat")
	else:
		self.lives -= 1
		$LivesLabel.text = (
			str(self.lives) + " " + ("lives" if self.lives > 1 else "life")
		)


func _on_PhaseTimer_timeout() -> void:
	if self.current_phase_index + 1 == self.phases.size():
		emit_signal("victory")
		return

	self.current_phase_index += 1
	self.current_phase = self.phases[self.current_phase_index]
