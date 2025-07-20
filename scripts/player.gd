class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
}

const STOP_ACCEL := 5.0
const MOVE_ACCEL := 10.0
const STOP_SPEED_THRESHOLD := 100

@export var speed := 200.0
@export var jump_power := 300.0
@export var max_fall_speed := 400.0

var _move_direction := 0.0
var _jump_just_pressed := false
var _state := State.IDLE

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _apply_gravity(delta: float) -> void:
	velocity.y += get_gravity().y * delta
	velocity.y = min(velocity.y, max_fall_speed)


func _get_input() -> void:
	_move_direction = Input.get_axis("left", "right")
	_jump_just_pressed = Input.is_action_just_pressed("jump")


func _apply_movement(delta: float) -> void:
	if is_on_floor():
		if _jump_just_pressed:
			velocity.y = -jump_power
	else:
		_apply_gravity(delta)

	var target_speed := _move_direction * speed
	var accel := STOP_ACCEL

	if _move_direction != 0.0:
		_sprite.flip_h = _move_direction < 0
		accel = MOVE_ACCEL

	velocity.x = move_toward(velocity.x, target_speed, accel)


func _set_state(new_state: State) -> void:
	if new_state == _state:
		return

	_state = new_state

	match _state:
		State.IDLE:
			_sprite.play("idle")
		State.RUN:
			_sprite.play("run")
		State.JUMP:
			_sprite.play("jump")
		State.FALL:
			_sprite.play("fall")


func _update_state() -> void:
	if is_on_floor():
		if _move_direction == 0 and abs(velocity.x) < STOP_SPEED_THRESHOLD:
			_set_state(State.IDLE)
		else:
			_set_state(State.RUN)
	else:
		if velocity.y < 0:
			_set_state(State.JUMP)
		else:
			_set_state(State.FALL)


func _physics_process(delta: float) -> void:
	_get_input()
	_apply_movement(delta)
	_update_state()
	move_and_slide()
