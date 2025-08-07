class_name GameState
extends RefCounted

enum State { TITLE, PLAYING, PAUSED, GAME_OVER }

const INITIAL_LIFE_COUNT := 3

var _current_state: State
var _life_count: int


func reset() -> void:
	_current_state = State.TITLE
	_life_count = INITIAL_LIFE_COUNT


func _init() -> void:
	reset()


func can_continue() -> bool:
	return _life_count > 0


func get_life_text() -> String:
	return "Life: %d" % _life_count


func decrease_life() -> bool:
	_life_count -= 1
	return can_continue()
