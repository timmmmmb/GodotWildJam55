extends KinematicBody2D

const DEADZONE = 0.3
const EPSILON = 0.0001

export var speed: float
export var radius: float
export var rotation_speed: float

var current_angle: float = 0.0
var target_angle: float = 0.0
var last_mouse_angle: float = 0.0
var last_controller_angle: float = 0.0
var target_rotation: float = 0.0


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
		self.target_angle = mouse_angle

	if abs(last_controller_angle - controller_angle) > EPSILON:
		self.target_angle = controller_angle

	self.last_controller_angle = controller_angle
	self.last_mouse_angle = mouse_angle


func _get_angle_delta(from: float, to: float, speeed: float, delta: float) -> float:
	from = _normalize_angle(from)
	var angle_delta = _normalize_angle(to - from)

	if angle_delta > PI:
		angle_delta -= TAU

	var max_delta = speed * delta

	return clamp(angle_delta, -max_delta, max_delta)


func _physics_process(delta: float) -> void:
	_update_target_angle()

	var angle_delta = _get_angle_delta(self.current_angle, self.target_angle, self.speed, delta)
	self.current_angle += angle_delta
	position = Vector2(radius, 0.0).rotated(self.current_angle)

	if angle_delta > 0:
		self.target_rotation = self.current_angle + PI / 2
	elif angle_delta < 0:
		self.target_rotation = self.current_angle - PI / 2

	var rotation_delta = _get_angle_delta(
		self.rotation, self.target_rotation, self.rotation_speed, delta
	)
	self.rotation += rotation_delta
