extends AudioStreamPlayer3D

# remove node when sfx finished
func _on_finished():
	self.queue_free()
