extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		SignalManager.game_completed.emit()
		print("Goal")
