extends CanvasLayer
@onready var ganaste = preload("res://Scenes/mainmenu.tscn") as PackedScene

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(ganaste)
