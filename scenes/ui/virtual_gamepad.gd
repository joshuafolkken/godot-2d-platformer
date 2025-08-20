extends Control

# ボタンとアクション名のマッピング
var _button_actions: Array[String] = [
	ActionName.LEFT,
	ActionName.RIGHT,
	ActionName.UP,
	ActionName.DOWN,
	ActionName.JUMP,
	ActionName.DASH,
	ActionName.RESET,
	ActionName.INTERACT
]


func get_button_name(action_name: String) -> String:
	return action_name.capitalize()


func get_action_name(button_name: String) -> String:
	return button_name.to_lower()


func _is_touch_device() -> bool:
	if DisplayServer.is_touchscreen_available():
		return true

	if OS.has_feature("web"):
		var navigator: JavaScriptObject = JavaScriptBridge.get_interface("navigator")
		@warning_ignore("unsafe_property_access")
		var user_agent: String = navigator.userAgent
		var mobile_keywords := ["Android", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"]
		for keyword: String in mobile_keywords:
			if keyword in user_agent:
				return true

	return false


func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)

	if not _is_touch_device():
		hide()
		return

	for action_name: String in _button_actions:
		var button_name := get_button_name(action_name)
		var parent_node_name := ""
		var touch_screen_button: TouchScreenButton

		if action_name in [ActionName.LEFT, ActionName.RIGHT, ActionName.UP, ActionName.DOWN]:
			parent_node_name = "Arrows"
		else:
			parent_node_name = "Buttons"

		var node_path := "%s/%s" % [parent_node_name, button_name]
		touch_screen_button = get_node_or_null(node_path)

		if touch_screen_button:
			touch_screen_button.pressed.connect(_on_touch_screen_button_pressed.bind(button_name))
			touch_screen_button.released.connect(_on_touch_screen_button_released.bind(button_name))


func _parse_input_event(action_name: String, pressed := true) -> void:
	var input_event := InputEventAction.new()
	input_event.action = action_name
	input_event.pressed = pressed
	Input.parse_input_event(input_event)


func _on_touch_screen_button_pressed(button_name: String) -> void:
	var action_name := get_action_name(button_name)
	if action_name:
		Input.action_press(action_name)
		AudioManager.play_sfx(AudioManager.SoundId.SYSTEM)


func _on_touch_screen_button_released(button_name: String) -> void:
	var action_name := get_action_name(button_name)
	if action_name:
		Input.action_release(action_name)


func _exit_tree() -> void:
	for action_name: String in _button_actions:
		Input.action_release(action_name)
