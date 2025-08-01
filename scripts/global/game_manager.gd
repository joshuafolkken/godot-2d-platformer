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
]

var _current_stage := INITIAL_STAGE_INDEX
var _current_life := INITIAL_LIFE_COUNT


func get_version() -> String:
	return "v%s" % ProjectSettings.get_setting("application/config/version")


func get_stage() -> String:
	return "Stage: %d/%d" % [_current_stage + 1, STAGES.size()]


func get_life() -> String:
	return "Life: %d" % _current_life


func _change_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)


func load_title_scene() -> void:
	_current_stage = INITIAL_STAGE_INDEX
	_current_life = INITIAL_LIFE_COUNT
	AudioManager.stop_all_sounds()
	_change_scene(TITLE_SCENE)


func load_stage(number: int) -> void:
	if number < 0 or number >= STAGES.size():
		load_title_scene()
		return

	var stage_scene: PackedScene = load("res://scenes/stages/stage-%s.tscn" % STAGES[number])
	_change_scene(stage_scene)


func load_next_stage() -> void:
	_current_stage += 1
	load_stage(_current_stage)
	AudioManager.stop_all_sounds()
	AudioManager.play_ambient(AudioManager.SoundId.BGM)


func _on_player_hit() -> void:
	_current_life -= 1
	life_changed.emit()

	if _current_life <= 0:
		player_died.emit()
	else:
		player_respawned.emit()


func _ready() -> void:
	SignalManager.player_hit.connect(_on_player_hit)
