extends Control

@onready var background: ColorRect = $Background
@onready var congrats: VBoxContainer = $Background/Congrats
@onready var game_over: VBoxContainer = $Background/GameOver
@onready var proceed_label: Label = $Background/Congrats/ProceedLabel
@onready var return_label: Label = $Background/GameOver/ReturnLabel


func hide_hud() -> void:
	background.visible = false


func show_hud() -> void:
	get_tree().paused = true
	background.visible = true


func _setup_labels() -> void:
	var format := "Press %s to %s"
	var key := "✓" if DeviceDetector.is_touch_device() else "F"
	proceed_label.text = format % [key, "Proceed"]
	return_label.text = format % [key, "Return"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	hide_hud()
	_setup_labels()
	SignalManager.game_completed.connect(_on_game_completed)
	GameManager.player_died.connect(_on_player_died)


func _on_game_completed() -> void:
	show_hud()
	AudioManager.stop_sound_type(AudioManager.SoundType.AMBIENT)
	AudioManager.play_sfx(AudioManager.SoundId.COMPLETE)


func _on_player_died() -> void:
	congrats.visible = false
	game_over.visible = true
	show_hud()
	AudioManager.stop_sound_type(AudioManager.SoundType.AMBIENT)
	AudioManager.play_sfx(AudioManager.SoundId.GAME_OVER)


func _process(_delta: float) -> void:
	if background.visible:
		if Input.is_action_just_pressed(ActionName.INTERACT):
			if congrats.visible:
				GameManager.load_next_stage()
			else:
				GameManager.load_title_scene()
