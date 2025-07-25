extends Node

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const LEVEL_SCENE: PackedScene = preload("res://scenes/level_base.tscn")

const STAGES: Array[String] = [
	"walk",
	"jump",
	"2-jumps",
	"3-jumps",
	"dash-jump",
	"dash-jump-2",
	"island",
	"island-2",
]

var _current_stage := -1


func _change_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)


func load_main_scene() -> void:
	_change_scene(MAIN_SCENE)
	_current_stage = 0


func load_stage(number: int) -> void:
	if number < 0 or number >= STAGES.size():
		load_main_scene()
		return

	var stage_scene: PackedScene = load("res://scenes/stage-%s.tscn" % STAGES[number])
	_change_scene(stage_scene)


func load_next_stage() -> void:
	_current_stage += 1
	load_stage(_current_stage)
