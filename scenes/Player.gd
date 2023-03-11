extends KinematicBody2D

export var speed: float
export var radius: float

var current_angle: float = 0.0


func _physics_process(delta: float) -> void:
	var viewport_center = get_viewport_rect().get_center()
	var mouse_position = get_viewport().get_mouse_position()

	var target_angle = (mouse_position - viewport_center).angle()
	var angle_delta = fposmod(target_angle - current_angle, TAU)

	if angle_delta > PI:
		angle_delta -= TAU

	var max_delta = speed * delta
	angle_delta = clamp(angle_delta, -max_delta, max_delta)

	current_angle += angle_delta
	position = Vector2(radius, 0.0).rotated(current_angle)
