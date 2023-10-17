extends Node3D

var intro_started: bool = false

# detect intro start input
func _input(event) -> void:
	if !intro_started and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select")):
		start_intro()

# start intro to title screen
func start_intro() -> void:
	# set intro as started
	intro_started = true;

	# hide intro
	$Intro.hide()

	# move camera towards screen
	var tween = create_tween().set_loops()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).tween_property($Camera, "position:x", -3.207, 1.3)
