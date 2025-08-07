extends GdUnitTestSuite

const _SCENE_PATH := "res://scenes/title.tscn"

var _runner: GdUnitSceneRunner


func before_test() -> void:
	_runner = scene_runner(_SCENE_PATH)


func test_scene_can_be_instantiated() -> void:
	var label: Label = _runner.find_child("CopyrightLabel")
	assert_str(label.text).is_equal("© 2025 Joshua Studio")
