class_name Player
extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
}

@export var _move_speed := 200.0
@export var _jump_forced := 300.0
@export var _max_y_velocity := 400.0

var _direction := Vector2.ZERO
var _state := State.IDLE

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _apply_gravity(delta: float) -> void:
	var gravity_accel := get_gravity().y * delta
	velocity.y += gravity_accel

	if velocity.y > _max_y_velocity:
		velocity.y = _max_y_velocity


func _get_input() -> void:
	_direction.x = Input.get_axis("left", "right")
	_direction.y = 1 if Input.is_action_just_pressed("jump") else 0


func _apply_movement(delta: float) -> void:
	if is_on_floor():
		if _direction.y > 0:
			velocity.y = -_jump_forced
	else:
		_apply_gravity(delta)

	if _direction.x:
		_sprite.flip_h = _direction.x < 0
		velocity.x = _direction.x * _move_speed
	else:
		velocity.x = 0


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
		if velocity.x == 0:
			_set_state(State.IDLE)
		else:
			_set_state(State.RUN)
	else:
		if velocity.y > 0:
			_set_state(State.JUMP)
		else:
			_set_state(State.FALL)


func _physics_process(delta: float) -> void:
	_get_input()
	_apply_movement(delta)
	_update_state()
	move_and_slide()
