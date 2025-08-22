extends Node


static func _make_emoji_fallback() -> SystemFont:
	var emoji_font := SystemFont.new()
	emoji_font.font_names = [
		# "system-ui",
		# "Arial",
		"Apple Color Emoji",
		"Segoe UI Emoji",
		"Noto Color Emoji",
	]

	return emoji_font


func _ready() -> void:
	# 既存のフォールバックを保ちつつ絵文字フォントを末尾に追加
	var fallback := ThemeDB.fallback_font
	var emoji := _make_emoji_fallback()

	# 二重追加を避ける
	for f in fallback.fallbacks:
		if f is not SystemFont:
			return

		var system_font: SystemFont = f
		if system_font.font_names == emoji.font_names:
			return

	fallback.fallbacks = fallback.fallbacks + [emoji]
