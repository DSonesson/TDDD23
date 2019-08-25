extends Sprite

signal towerPressed(tower)

func _ready():
	pass


func _on_TextureButton_toggled(button_pressed):
	emit_signal("towerPressed", self)
