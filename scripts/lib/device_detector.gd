class_name DeviceDetector

const MOBILE_KEYWORDS: Array[String] = [
	"Android", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"
]


static func _is_mobile_web_browser() -> bool:
	var navigator: JavaScriptObject = JavaScriptBridge.get_interface("navigator")
	@warning_ignore("unsafe_property_access")
	var user_agent: String = navigator.userAgent

	for keyword: String in MOBILE_KEYWORDS:
		if keyword in user_agent:
			return true

	return false


static func is_touch_device() -> bool:
	if DisplayServer.is_touchscreen_available():
		return true

	if OS.has_feature("web"):
		return _is_mobile_web_browser()

	return false
