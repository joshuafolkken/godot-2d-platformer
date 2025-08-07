class_name StageManager
extends RefCounted

const INITIAL_STAGE_INDEX := -1

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

var _stage_index: int


func reset() -> void:
	_stage_index = INITIAL_STAGE_INDEX


func _init() -> void:
	reset()


func _get_stage_path() -> String:
	return "res://scenes/stages/stage-%s.tscn" % STAGES[_stage_index]


func _is_valid_stage() -> bool:
	return _stage_index >= 0 and _stage_index < STAGES.size()


func get_display_text() -> String:
	return "Stage: %d/%d" % [_stage_index + 1, STAGES.size()]


func next() -> bool:
	_stage_index += 1
	return _is_valid_stage()
