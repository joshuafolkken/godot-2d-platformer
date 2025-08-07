extends Node

signal life_changed
signal player_respawned
signal player_died

var _game_state: GameState
var _stage_manager: StageManager
var _scene_manager: SceneManager


func _initialize_managers() -> void:
	_game_state = GameState.new()
	_stage_manager = StageManager.new()
	_scene_manager = SceneManager.new()


func _connect_signals() -> void:
	SignalManager.player_hit.connect(_on_player_hit)


func _ready() -> void:
	_connect_signals()
	_initialize_managers()


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
	Log.d()
	if not _stage_manager.next():
		Settings.increment_clear_count()
		load_title_scene()
		return

	Log.d()
	var stage_path := _stage_manager._get_stage_path()
	Log.d()
	_scene_manager.load_stage(stage_path)
	Log.d()


func _on_player_hit() -> void:
	var can_continue := _game_state.decrease_life()
	life_changed.emit()

	if not can_continue:
		player_died.emit()
	else:
		player_respawned.emit()
