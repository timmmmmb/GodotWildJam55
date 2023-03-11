extends KinematicBody2D

const DEADZONE = 0.3
const EPSILON = 0.0001

export var speed: float
export var radius: float

var current_angle: float = 0.0
var target_angle: float = 0.0
var last_mouse_angle: float = 0.0
var last_controller_angle: float = 0.0


func _normalize_angle(angle: float) -> float:
	return fposmod(angle, TAU)


func _get_mouse_angle() -> float:
	var viewport_center = get_viewport_rect().get_center()
	var mouse_position = get_viewport().get_mouse_position()
	var angle = (mouse_position - viewport_center).angle()
	return _normalize_angle(angle)


func _get_controller_angle() -> float:
	var x = Input.get_joy_axis(0, JOY_ANALOG_LX)
	var y = Input.get_joy_axis(0, JOY_ANALOG_LY)
	var direction = Vector2(x, y)

	if direction.length() <= DEADZONE:
		return last_controller_angle

	return _normalize_angle(direction.angle())


func _update_target_angle() -> void:
	var controller_angle = _get_controller_angle()
	var mouse_angle = _get_mouse_angle()

	if abs(last_mouse_angle - mouse_angle) > EPSILON:
		target_angle = mouse_angle

	if abs(last_controller_angle - controller_angle) > EPSILON:
		target_angle = controller_angle

	last_controller_angle = controller_angle
	last_mouse_angle = mouse_angle


func _physics_process(delta: float) -> void:
	_update_target_angle()
	var angle_delta = _normalize_angle(target_angle - current_angle)

	if angle_delta > PI:
		angle_delta -= TAU

	var max_delta = speed * delta
	angle_delta = clamp(angle_delta, -max_delta, max_delta)

	current_angle += angle_delta
	position = Vector2(radius, 0.0).rotated(current_angle)
