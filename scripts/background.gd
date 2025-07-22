extends ParallaxBackground

@export var texture : CompressedTexture2D = preload("res://assets/Background/Gray.png")
@export var scroll_speed := 50.0

@onready var sprite: Sprite2D = $ParallaxLayer/Sprite2D


func _ready() -> void:
	sprite.texture = texture


func _process(delta: float) -> void:
	sprite.region_rect.position += delta * Vector2(scroll_speed, scroll_speed)

	if sprite.region_rect.position >= Vector2(64.0, 64.0):
		sprite.region_rect.position = Vector2.ZERO
