extends Control

@onready var label: Label = $Label


func _update() -> void:
	label.text = GameManager.get_life()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update()

	GameManager.life_changed.connect(_update)
