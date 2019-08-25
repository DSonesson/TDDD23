extends TextureButton

onready var label = get_node("Label")

func _ready():
	label.hide()

func _on_waveStartButton_mouse_entered():
	label.show()

func _on_waveStartButton_mouse_exited():
	label.hide()
