extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_all_sounds()
	get_tree().paused = false
	AudioManager.play_ambient(AudioManager.SoundId.BGM)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(ActionName.RESET):
		GameManager.load_title_scene()
