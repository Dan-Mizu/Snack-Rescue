extends Node3D

# references
@export var sfx_button_press: PackedScene
@onready var screen_text: Label3D = $Screen/Text
@onready var sfx_error: AudioStreamPlayer3D = $Screen/sfx_error

# state
var letter: String = ""
var number: String = ""
var processing: bool = false

# triggers on numpad interaction click
func _on_a_input_event(_camera: Node, event: InputEvent, click_position: Vector3, _normal: Vector3, _shape_idx: int, interacted: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			play_sound(click_position)
		elif event.is_released():
			play_sound(click_position)
			clicked_button(interacted)

# play a sound
func play_sound(sound_position: Vector3) -> void:
	# play sound
	var audio_source = sfx_button_press.instantiate()

	# change parent
	get_tree().get_root().add_child(audio_source)

	# place audio source at button press location
	audio_source.position = sound_position

	# play sound
	audio_source.play()

# numpad button clicked
func clicked_button(button: String) -> void:
		# ignore if processing
		if processing:
			return

		# letter
		if letter == "" and (button == "A" or button == "B" or button ==  "C" or button == "D"):
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.3).timeout
			processing = false

			# store letter
			letter = button

			# update screen
			screen_text.text = letter

		# number
		elif letter != "" and (button != "A" and button != "B" and button !=  "C" and button != "D") and (((letter == "A" or letter == "B") and int(button) <= 3) or ((letter == "C" or letter == "D") and int(button) <= 6)):
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.3).timeout
			processing = false

			# store number
			number = button

			# update screen
			screen_text.text = letter + number

			# trigger spin of spiral for corresponding item
			await get_tree().create_timer(2).timeout
			letter = ""
			number = ""
			screen_text.text = ""

		# wrong input
		else:
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.5).timeout
			processing = false

			# play error sound
			sfx_error.play()
