class_name DeviceDetector

const MOBILE_KEYWORDS: Array[String] = [
	"Android",
	"iPhone",
	"iPad",
	"iPod",
	"BlackBerry",
	"Windows Phone",
]


static func is_mobile_web_browser() -> bool:
	if not OS.has_feature("web"):
		return false

	var navigator: JavaScriptObject = JavaScriptBridge.get_interface("navigator")
	@warning_ignore("unsafe_property_access") var user_agent: String = navigator.userAgent

	for keyword: String in MOBILE_KEYWORDS:
		if keyword in user_agent:
			return true

	return false


static func is_touch_device() -> bool:
	if DisplayServer.is_touchscreen_available():
		return true

	return is_mobile_web_browser()


static func supports_fullscreen() -> bool:
	if not OS.has_feature("web"):
		return true

	if JavaScriptBridge.eval("!!(document.fullscreenEnabled || document.webkitFullscreenEnabled)"):
		return true

	return false


static func try_request_fullscreen_via_js() -> bool:
	if not OS.has_feature("web"):
		return false

	var js := """
	(function(){
		var canvas = document.getElementById('canvas') || document.documentElement;
		var req = canvas.requestFullscreen
			|| canvas.webkitRequestFullscreen
			|| canvas.webkitEnterFullscreen;
		if (!req) return false;
		try { req.call(canvas); return true; } catch(e) { return false; }
	})()
	"""

	var ok: bool = JavaScriptBridge.eval(js)

	return ok == true


static func set_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return

	if not OS.has_feature("web"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return

	if DeviceDetector.supports_fullscreen():
		var ok := DeviceDetector.try_request_fullscreen_via_js()
		if not ok:
			OS.alert("Add to Home Screen for full screen.")
	else:
		OS.alert("Add to Home Screen for full screen.")


static func _is_pwa() -> bool:
	if not OS.has_feature("web"):
		return false

	var js := """
	(function(){
		var modes = ['fullscreen','standalone','minimal-ui'];

		var byDisplayMode = !!(window.matchMedia) && modes.some(function(m){
			return window.matchMedia('(display-mode: ' + m + ')').matches;
		});

		var iosStandalone = (typeof navigator !== 'undefined')
			&& (typeof navigator.standalone !== 'undefined')
			&& navigator.standalone;
		return !!(byDisplayMode || iosStandalone);
	})()
	"""

	var ret: bool = JavaScriptBridge.eval(js)
	return ret == true


static func can_fullscreen() -> bool:
	return not is_mobile_web_browser() or _is_pwa()
