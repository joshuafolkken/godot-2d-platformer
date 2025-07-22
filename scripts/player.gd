class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
}

const ANIMATIONS: Dictionary[State, String] = {
	State.IDLE: AnimationName.IDLE,
	State.RUN: AnimationName.RUN,
	State.JUMP: AnimationName.JUMP,
	State.FALL: AnimationName.FALL,
}

@export_group("Movement")
@export var normal_speed := 150.0
@export var dash_speed := 300.0
@export var stop_speed_threshold := 100.0
@export var fall_off_y := 100.0

@export_group("Jumping")
@export var jump_power := 300.0
@export var jump_hold_time := 0.3
@export var max_fall_speed := 400.0
@export var gravity_ratio := 2

@export_group("Acceleration")
@export var stop_acceleration := 5.0
@export var move_acceleration := 10.0

var _jump_time := 0.0
var _current_state := State.IDLE

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _get_input_direction() -> float:
	return Input.get_axis(ActionName.LEFT, ActionName.RIGHT)


func _can_jump(delta: float) -> bool:
	if is_on_floor():
		_jump_time = 0
	else:
		_jump_time += delta

	return _jump_time <= jump_hold_time


func _is_jump_pressed() -> bool:
	return Input.is_action_pressed(ActionName.JUMP)


func _is_dash_pressed() -> bool:
	return Input.is_action_pressed(ActionName.DASH)


func _apply_gravity(delta: float) -> void:
	velocity.y += get_gravity().y * gravity_ratio * delta
	velocity.y = min(velocity.y, max_fall_speed)


func _handle_jump(delta: float) -> void:
	if _can_jump(delta) and _is_jump_pressed():
		velocity.y = -((1 + _jump_time) * jump_power)
	else:
		_apply_gravity(delta)


func _set_state(new_state: State) -> void:
	if new_state == _current_state:
		return

	_current_state = new_state
	_sprite.play(ANIMATIONS[_current_state])


func _update_state(is_moving: bool) -> void:
	if is_on_floor():
		if !is_moving and abs(velocity.x) < stop_speed_threshold:
			_set_state(State.IDLE)
		else:
			_set_state(State.RUN)
	else:
		if velocity.y < 0:
			_set_state(State.JUMP)
		else:
			_set_state(State.FALL)


func _handle_horizontal_move() -> void:
	var input_direction := _get_input_direction()
	var speed := dash_speed if _is_dash_pressed() else normal_speed
	var target_speed := input_direction * speed
	var acceleration := move_acceleration if input_direction != 0.0 else stop_acceleration

	velocity.x = move_toward(velocity.x, target_speed, acceleration)

	var is_moving := input_direction != 0.0

	if is_moving:
		_sprite.flip_h = input_direction < 0

	_update_state(is_moving)


func _emit_player_hit() -> void:
	SignalManager.on_player_hit.emit()


func _fallen_off() -> void:
	if global_position.y > fall_off_y:
		_emit_player_hit()


func _physics_process(delta: float) -> void:
	_handle_jump(delta)
	_handle_horizontal_move()
	_fallen_off()
	move_and_slide()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if !area.is_in_group(GroupName.TRAP):
		return

	velocity = Vector2.ZERO
	_emit_player_hit()


func reset() -> void:
	_sprite.flip_h = false
