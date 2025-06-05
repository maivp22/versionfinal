extends Node2D

@export var next_button : PackedScene
@export var quest_button : PackedScene

var dialogue: Dialogue:
	set(value):
		dialogue = value
		
		if current_speaker:
			current_speaker.dialogue = value
		
		%Icon.texture = value.texture
		$%Name.text = value.name
		%Dialogue.text = value.dialogue
		
		reset_options()

		add_buttons(value.options)
		
		await get_tree().create_timer(0.5).timeout
		%Options.show()

var current_speaker = null


func reset_options():
	for child in %Options.get_children():
		child.queue_free()
	%Options.hide()

func add_buttons(options):
	for option in options:
		if option == null:
			print("⚠️ Se detectó una opción nula, ignorando...")
			continue
		var button = next_button.instantiate()
		button.dialogue = option
		%Options.add_child(button)

func hide_dialogue():
	%UI.hide()

func show_dialogue():
	%UI.show()
