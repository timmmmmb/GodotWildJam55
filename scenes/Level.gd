extends Node2D

signal win

export (Array, NodePath) var spawn_points := []
var spawn_point_nodes := []

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


func _ready() -> void:
	for spawn_point in self.spawn_points:
		self.spawn_point_nodes.push_back(get_node(spawn_point))


func _on_SpawnTimer_timeout() -> void:
	_spawn_dream()


func _spawn_dream():
	var dream = _randomly_select_dream().instance()
	var spawn_point = self.spawn_point_nodes[randi() % self.spawn_points.size()]

	dream.position = spawn_point.position
	add_child(dream)


func _randomly_select_dream() -> Resource:
	var dreams = self.current_phase.dreams
	var random_value = randf()

	for dream in dreams:
		if dream.probability >= random_value:
			return dream.scene

		random_value -= dream.probability

	return GoodDream


func _on_PhaseTimer_timeout() -> void:
	if self.current_phase_index + 1 == self.phases.size():
		emit_signal("win")
		return

	self.current_phase_index += 1
	self.current_phase = self.phases[self.current_phase_index]
