extends Node2D

@onready var start_button: Button = $CanvasLayer/MainMenu/MenuOptions/StartButton
@onready var quit_button: Button = $CanvasLayer/MainMenu/MenuOptions/QuitButton
@onready var clear_count_label: Label = $CanvasLayer/ClearCountLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	start_button.grab_focus()
	quit_button.visible = OS.get_name() != "Web"
	clear_count_label.text = (
		"PLAYS: %d  CLEARS: %d" % [Settings.load_play_count(), Settings.load_clear_count()]
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed(ActionName.F):
	#GameManager.load_next_stage()


func _on_start_button_pressed() -> void:
	Settings.increment_play_count()
	GameManager.load_next_stage()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(ActionName.DOWN):
		var current_focus := get_viewport().gui_get_focus_owner()
		var next_focus := current_focus.find_next_valid_focus()
		next_focus.grab_focus()
	elif Input.is_action_just_pressed(ActionName.UP):
		var current_focus := get_viewport().gui_get_focus_owner()
		var next_focus := current_focus.find_prev_valid_focus()
		next_focus.grab_focus()


func _on_start_button_focus_entered() -> void:
	AudioManager.play_sfx(AudioManager.SoundId.SYSTEM)


func _on_quit_button_focus_entered() -> void:
	AudioManager.play_sfx(AudioManager.SoundId.SYSTEM)
