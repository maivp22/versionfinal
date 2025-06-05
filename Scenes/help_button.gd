extends CanvasLayer


func _on_help_button_pressed() -> void:
	get_tree().paused = true
	$HelpPopup.visible = true
