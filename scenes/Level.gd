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
		"spawn_interval": 1.2,
		"dreams": [
			{"scene": BadDream, "probability": 1}
		]
	},
	{
		"spawn_interval": 1.1,
		"dreams":
		[
			{"scene": GoodDream, "probability": 0.25},
			{"scene": BadDream, "probability": 0.75}
		]
	},
	{
		"spawn_interval": 1.0,
		"dreams":
		[
			{"scene": GoodDream, "probability": 0.2},
			{"scene": BadDream, "probability": 0.4},
			{"scene": FastDream, "probability": 0.4},
		]
	},
	{
		"spawn_interval": 0.9,
		"dreams":
		[
			{"scene": GoodDream, "probability": 0.2},
			{"scene": BadDream, "probability": 0.2},
			{"scene": FastDream, "probability": 0.2},
			{"scene": RandomDream, "probability": 0.2},
			{"scene": SpiralDream, "probability": 0.2}
		]
	},
	{
		"spawn_interval": 0.8,
		"dreams":
		[
			{"scene": GoodDream, "probability": 0.2},
			{"scene": BadDream, "probability": 0.2},
			{"scene": FastDream, "probability": 0.2},
			{"scene": RandomDream, "probability": 0.2},
			{"scene": SpiralDream, "probability": 0.2}
		]
	}
]

var current_phase_index = 0
var current_phase = phases[0]

func _ready() -> void:
	_load_phase(0)


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
		$LivesLabel.text = "DEFEAT"
	else:
		self.lives -= 1
		$LivesLabel.text = (
			str(self.lives) + " " + ("lives" if self.lives > 1 else "life")
		)


func _on_PhaseTimer_timeout() -> void:
	if self.current_phase_index + 1 == self.phases.size():
		emit_signal("victory")
		$LivesLabel.text = "VICTORY"
		return

	self.current_phase_index += 1
	_load_phase(self.current_phase_index)


func _load_phase(index: int) -> void:
	self.current_phase = self.phases[index]
	$SpawnTimer.wait_time = self.current_phase.spawn_interval
	print("phase ", self.current_phase_index + 1, " out of ", self.phases.size())
