extends CanvasLayer

@onready var help_popup = $HelpPopup
@onready var help_button = $HelpButton
@onready var close_button = $HelpPopup/CloseButton

func _ready():
	help_button.pressed.connect(_on_help_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	help_popup.visible = false

func _on_help_button_pressed() -> void:
	get_tree().paused = true
	help_popup.popup_centered()

func _on_close_button_pressed() -> void:
	help_popup.hide()



func _on_help_popup_popup_hide() -> void:
	get_tree().paused = false
