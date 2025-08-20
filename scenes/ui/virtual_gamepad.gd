extends Control

const MOBILE_KEYWORDS: Array[String] = [
	"Android", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"
]
const ARROW_ACTIONS: Array[String] = [
	ActionName.LEFT, ActionName.RIGHT, ActionName.UP, ActionName.DOWN
]
const BUTTON_ACTIONS: Array[String] = [
	ActionName.JUMP, ActionName.DASH, ActionName.RESET, ActionName.INTERACT
]

var _actions := ARROW_ACTIONS + BUTTON_ACTIONS


func get_button_name(action_name: String) -> String:
	return action_name.capitalize()


func get_action_name(button_name: String) -> String:
	return button_name.to_lower()


func _is_mobile_web_browser() -> bool:
	var navigator: JavaScriptObject = JavaScriptBridge.get_interface("navigator")
	@warning_ignore("unsafe_property_access")
	var user_agent: String = navigator.userAgent

	for keyword: String in MOBILE_KEYWORDS:
		if keyword in user_agent:
			return true

	return false


func _is_touch_device() -> bool:
	if DisplayServer.is_touchscreen_available():
		return true

	if OS.has_feature("web"):
		return _is_mobile_web_browser()

	return false


func _get_parent_node_name(action_name: String) -> String:
	return "Arrows" if action_name in ARROW_ACTIONS else "Buttons"


func _setup_button(action_name: String) -> void:
	var button_name := get_button_name(action_name)
	var parent_node_name := _get_parent_node_name(action_name)
	var node_path := "%s/%s" % [parent_node_name, button_name]

	var touch_screen_button: TouchScreenButton = get_node_or_null(node_path)

	if not touch_screen_button:
		return

	touch_screen_button.pressed.connect(_on_pressed.bind(button_name))
	touch_screen_button.released.connect(_on_released.bind(button_name))


func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

	if not _is_touch_device():
		hide()
		return

	for action_name: String in _actions:
		_setup_button(action_name)


func _on_pressed(button_name: String) -> void:
	var action_name := get_action_name(button_name)
	if action_name:
		Input.action_press(action_name)


func _on_released(button_name: String) -> void:
	var action_name := get_action_name(button_name)
	if action_name:
		Input.action_release(action_name)


func _exit_tree() -> void:
	for action_name: String in _actions:
		Input.action_release(action_name)
