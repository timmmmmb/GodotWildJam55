class_name Dream
extends Area2D

signal loose_life

enum DreamType { GOOD, BAD, UNKNOWN }

export var speed: Vector2 = Vector2(100.0, 0.0)
export (DreamType) var dream_type = DreamType.GOOD

const center_radius: float = 30.0

var dead = false

const good_dream_images = [
	preload("res://assets/GoodDream1.png"),
	preload("res://assets/GoodDream2.png")
]

const bad_dream_images = [
	preload("res://assets/BadDream1.png"),
	preload("res://assets/BadDream2.png"),
	preload("res://assets/BadDream3.png")
]


func _ready() -> void:
	_set_dream_texture()
	if self.position.x > 0:
		$Sprite.scale.y *= -1


func _set_dream_texture() -> void:
	if self.dream_type == DreamType.GOOD:
		$Sprite.texture = self.good_dream_images[randi() % self.good_dream_images.size()]
	if self.dream_type == DreamType.BAD:
		$Sprite.texture = self.bad_dream_images[randi() % self.bad_dream_images.size()]


func _physics_process(delta: float) -> void:
	if dead:
		return
	look_at(Vector2.ZERO)

	self.position += self.speed.rotated(self.rotation) * delta

	if position.abs().length() < center_radius:
		_on_center_entered()

	for body in self.get_overlapping_bodies():
		if body.is_in_group("dreamcatcher"):
			_on_collission_with_dreamcatcher()


func _on_collission_with_dreamcatcher() -> void:
	if dead:
		return
	self.visible = false
	$AudioStreamPlayer2D.play()
	if self.dream_type == DreamType.GOOD:
		emit_signal("loose_life")
	dead = true


func _on_center_entered() -> void:
	get_parent().remove_child(self)

	if self.dream_type == DreamType.BAD:
		emit_signal("loose_life")


func _on_AudioStreamPlayer2D_finished() -> void:
	get_parent().remove_child(self)
