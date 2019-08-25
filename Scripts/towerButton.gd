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
		background.hide()
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
	pressed = false
	disabled = true
	update_label(0, 0)

func update_label(placed, left):
		var new_text = "Outpost \n Place an outpost that automatically \n fires at the closest mob. \n Leveling up alows more towers to be \nplaced"
#		var new_text2 = new_text % [String(placed), String(left)]
		label.set_text(new_text)

func _on_towerButton_mouse_entered():
	label.show()

func _on_towerButton_mouse_exited():
	label.hide()
