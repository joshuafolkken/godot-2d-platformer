extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label: Label = $Label
	label.text = GameManager.get_stage()
