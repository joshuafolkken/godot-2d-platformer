extends StaticBody2D

@onready var player: Player = get_tree().get_first_node_in_group(GroupName.PLAYER)
@onready var spawn_maker: Marker2D = $Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_player_hit.connect(_on_player_hit)
	_on_player_hit()


func _on_player_hit() -> void:
	player.global_position = spawn_maker.global_position
	player.reset()
