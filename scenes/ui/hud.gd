extends Control

@onready var background: ColorRect = $Background
@onready var congrats: VBoxContainer = $Background/Congrats
@onready var game_over: VBoxContainer = $Background/GameOver


func hide_hud() -> void:
	background.visible = false


func show_hud() -> void:
	get_tree().paused = true
	background.visible = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	hide_hud()
	SignalManager.game_completed.connect(_on_game_completed)
	GameManager.player_died.connect(_on_player_died)


func _on_game_completed() -> void:
	show_hud()


func _on_player_died() -> void:
	congrats.visible = false
	game_over.visible = true
	show_hud()


func _process(_delta: float) -> void:
	if background.visible:
		if Input.is_action_just_pressed(ActionName.F):
			if congrats.visible:
				GameManager.load_next_stage()
			else:
				GameManager.load_main_scene()
