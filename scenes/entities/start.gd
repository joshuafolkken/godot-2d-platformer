extends StaticBody2D

@onready var player: Player = get_tree().get_first_node_in_group(GroupName.PLAYER)
@onready var spawn_maker: Marker2D = $Marker2D


func reset_player_position() -> void:
	player.global_position = spawn_maker.global_position
	player.reset()
	AudioManager.play_sfx(AudioManager.SoundId.START)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_respawned.connect(reset_player_position)
	reset_player_position()
