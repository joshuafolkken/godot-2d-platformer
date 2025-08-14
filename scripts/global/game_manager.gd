extends Node

signal life_changed
signal player_respawned
signal player_died

const INITIAL_STAGE_INDEX := -1
const INITIAL_LIFE_COUNT := 3

const TITLE_SCENE: PackedScene = preload("res://scenes/title.tscn")

const STAGES: Array[String] = [
	"walk",
	"jump",
	"2-jumps",
	"3-jumps",
	"3-jumps-2",
	"dash-jump",
	"dash-jump-2",
	"island",
	"island-2",
	"midair-jump",
	"midair-jump-2",
	"final",
	"walk-2",
	"spikes",
	"spikes-2",
	"holed-mountain",
	"holed-mountain-2",
]

var _current_stage := INITIAL_STAGE_INDEX
var _current_life := INITIAL_LIFE_COUNT


func get_version() -> String:
	return "v%s" % ProjectSettings.get_setting("application/config/version")


func get_stage() -> String:
	return _stage_manager.get_display_text()


func get_life() -> String:
	return _game_state.get_life_text()


func load_title_scene() -> void:
	_game_state.reset()
	_stage_manager.reset()
	_scene_manager.load_title()


func load_next_stage() -> void:
	if not _stage_manager.next():
		Settings.increment_clear_count()
		load_title_scene()
		return

	var stage_path := _stage_manager._get_stage_path()
	_scene_manager.load_stage(stage_path)


func _on_player_hit() -> void:
	var can_continue := _game_state.decrease_life()
	life_changed.emit()

	if not can_continue:
		player_died.emit()
	else:
		player_respawned.emit()
