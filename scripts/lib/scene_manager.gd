class_name SceneManager
extends RefCounted

const TITLE_SCENE: PackedScene = preload("res://scenes/title.tscn")


func _change_scene(packed_scene: PackedScene) -> void:
	var tree: SceneTree = Engine.get_main_loop()
	tree.change_scene_to_packed(packed_scene)


func load_title() -> void:
	_change_scene(TITLE_SCENE)


func load_stage(stage_path: String) -> void:
	var stage_scene: PackedScene = load(stage_path)
	_change_scene(stage_scene)
