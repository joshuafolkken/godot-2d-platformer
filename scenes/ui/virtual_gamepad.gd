class_name VirtualGamePad
extends Control

const ARROW_ACTIONS: Array[String] = [
	ActionName.LEFT, ActionName.RIGHT, ActionName.UP, ActionName.DOWN
]
const BUTTON_ACTIONS: Array[String] = [
	ActionName.JUMP, ActionName.DASH, ActionName.RESET, ActionName.INTERACT
]

var _actions := ARROW_ACTIONS + BUTTON_ACTIONS


func _get_button_name(action_name: String) -> String:
	return action_name.capitalize()


func _get_action_name(button_name: String) -> String:
	return button_name.to_lower()


func _get_parent_node_name(action_name: String) -> String:
	return "Arrows" if action_name in ARROW_ACTIONS else "Buttons"


func _setup_button(action_name: String) -> void:
	var button_name := _get_button_name(action_name)
	var parent_node_name := _get_parent_node_name(action_name)
	var node_path := "%s/%s" % [parent_node_name, button_name]

	var touch_screen_button: TouchScreenButton = get_node_or_null(node_path)

	if not touch_screen_button:
		return

	touch_screen_button.passby_press = true
	touch_screen_button.pressed.connect(_on_pressed.bind(button_name))
	touch_screen_button.released.connect(_on_released.bind(button_name))


func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

	if not DeviceDetector.is_touch_device():
		hide()
		return

	for action_name: String in _actions:
		_setup_button(action_name)


func _on_pressed(button_name: String) -> void:
	var action_name := _get_action_name(button_name)
	if action_name:
		Input.action_press(action_name)


func _on_released(button_name: String) -> void:
	var action_name := _get_action_name(button_name)
	if action_name:
		Input.action_release(action_name)


func _exit_tree() -> void:
	for action_name: String in _actions:
		Input.action_release(action_name)
