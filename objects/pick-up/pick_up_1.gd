extends Area3D




func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.emit_signal("update_score")
		Global.player_ammo_A += 2
		Global.player_ammo_D += 1
		Global.emit_signal("ammo_pick")
		print("more ammo")
		queue_free()
		
