class_name Dream
extends Area2D

signal loose_life

enum DreamType { GOOD, BAD }

export var speed: Vector2 = Vector2(100.0, 0.0)
export (DreamType) var dream_type = DreamType.GOOD

const center_radius: float = 30.0


func _physics_process(delta: float) -> void:
	look_at(Vector2.ZERO)

	self.position += self.speed.rotated(self.rotation) * delta

	if position.abs().length() < center_radius:
		_on_center_entered()

	for body in self.get_overlapping_bodies():
		if body.is_in_group("dreamcatcher"):
			_on_collission_with_dreamcatcher()


func _on_collission_with_dreamcatcher() -> void:
	get_parent().remove_child(self)

	if self.dream_type == DreamType.GOOD:
		emit_signal("loose_life")


func _on_center_entered() -> void:
	get_parent().remove_child(self)

	if self.dream_type == DreamType.BAD:
		emit_signal("loose_life")
