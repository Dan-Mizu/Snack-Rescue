extends Node3D

@export var sfx_button_press: PackedScene

# triggers on numpad interaction click
func _on_a_input_event(_camera: Node, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int, _interacted: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			play_sound(position)
		elif event.is_released():
			play_sound(position)

# play a sound
func play_sound(position: Vector3) -> void:
	# play sound
	var audio_source = sfx_button_press.instantiate()

	# change parent
	get_tree().get_root().add_child(audio_source)

	# place audio source at button press location
	audio_source.position = position

	# play sound
	audio_source.play()
