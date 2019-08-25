extends TextureButton


onready var label = get_node("Label")
onready var background = get_node("background")
onready var disabledPanel = get_node("Node2D/disabledPanel")

func _process(delta):
	if pressed:
		background.show()
		release_focus()
	else:
		background.hide()
	
	if disabled:
		disabledPanel.show()
	else:
		disabledPanel.hide()

func disableButton():
	disabled = true
	pressed = false

func enableButton():
	disabled = false

func _ready():
	background.hide()
	label.hide()
	disabledPanel.hide()
	update_label(0,0)

func update_label(placed, left):
		var new_text = "Stone \n Mobs cannot run through stones and \n will have to run around them. \n Leveling up alows you to place more \n stones."
#		var new_text2 = new_text % [String(placed), String(left)]
		label.set_text(new_text)

func _on_stoneButton_mouse_entered():
	label.show()

func _on_stoneButton_mouse_exited():
	label.hide()
