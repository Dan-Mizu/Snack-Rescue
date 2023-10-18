extends Node3D

# references
@export var sfx_button_press: PackedScene
@onready var sfx_error: AudioStreamPlayer3D = $Screen/sfx_error
@onready var screen_text: Label3D = $Screen/Text

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
		if letter == "" and is_input_letter(button):
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.3).timeout
			processing = false

			# store letter
			letter = button

			# update screen
			screen_text.text = letter

		# number
		elif letter != "" and not is_input_letter(button) and ((is_double_spiral(letter) and int(button) <= 3) or (not is_double_spiral(letter) and int(button) <= 6)):
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.3).timeout

			# store number
			number = button

			# update screen
			screen_text.text = letter + number

			# trigger spin of spiral for corresponding item
			drop_item()

		# wrong input
		else:
			# wait a second to create illusion of slow processing
			processing = true
			await get_tree().create_timer(0.5).timeout
			processing = false

			# play error sound
			sfx_error.play()

# spin spiral to drop item
func drop_item() -> void:
	# get input
	var input: String = letter + number
	
	# init tween
	var tween = create_tween().set_loops(1).set_parallel(true)
	tween.connect("finished", reset_input)

	# spin spiral
	if is_double_spiral(letter):
		# start tween
		tween.tween_property(get_node("Vending Machine/Spirals/" + input + " Left"), "rotation:z", deg_to_rad(-360), 3).as_relative()
		tween.tween_property(get_node("Vending Machine/Spirals/" + input + " Right"), "rotation:z", deg_to_rad(360), 3).as_relative()
	else:
		tween.tween_property(get_node("Vending Machine/Spirals/" + input), "rotation:z", deg_to_rad(-360), 3).as_relative()

func reset_input() -> void:
	print("reset")
	# reset screen
	letter = ""
	number = ""
	screen_text.text = ""

	# allow input
	processing = false

# check if input is double spiral
func is_double_spiral(input: String) -> bool:
	if (input == "A" or input == "B"):
		return true
	else:
		return false

# check if input is letter
func is_input_letter(input: String) -> bool:
	if input == "A" or input == "B" or input ==  "C" or input == "D":
		return true
	else:
		return false
