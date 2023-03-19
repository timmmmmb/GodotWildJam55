extends Node2D

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
	randomize()
	$LivesLabel.visible = true
	_load_phase(0)


func _process(_delta: float) -> void:
	var is_last_phase = self.current_phase_index == self.phases.size() - 1
	var no_dreams_left = get_tree().get_nodes_in_group("dream").size() == 0
	
	if is_last_phase and no_dreams_left:
		$LivesLabel.visible = false
		$End/VictoryLabel.visible = true
		get_tree().paused = true


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
	self.lives -= 1
	$LivesLabel.text = str(self.lives) + " " + ("lives" if self.lives > 1 else "life")
		
	if self.lives == 0:
		$LivesLabel.visible = false
		$End/DefeatLabel.visible = true
		get_tree().paused = true


func _on_PhaseTimer_timeout() -> void:
	if self.current_phase_index + 1 == self.phases.size():
		$SpawnTimer.stop()
		return

	self.current_phase_index += 1
	_load_phase(self.current_phase_index)


func _load_phase(index: int) -> void:
	self.current_phase = self.phases[index]
	$SpawnTimer.wait_time = self.current_phase.spawn_interval
	print("phase ", self.current_phase_index + 1, " out of ", self.phases.size())
