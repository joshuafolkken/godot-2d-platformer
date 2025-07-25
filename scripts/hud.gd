extends Control

@onready var background: ColorRect = $Background


func hide_hud() -> void:
	background.visible = false


func show_hud() -> void:
	get_tree().paused = true
	background.visible = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	hide_hud()
	SignalManager.on_game_complete.connect(_on_game_complete)


func _on_game_complete() -> void:
	show_hud()


func _process(_delta: float) -> void:
	if background.visible:
		if Input.is_action_just_pressed(ActionName.F):
			GameManager.load_next_stage()
