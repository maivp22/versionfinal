extends Node

var help_ui_instance

func _ready():
	var scene = preload("res://Scenes/HelpUI.tscn")
	help_ui_instance = scene.instantiate()
	get_tree().root.add_child(help_ui_instance)
	help_ui_instance.set_layer(100)  

	# Debug
	print("Help UI cargado correctamente")
