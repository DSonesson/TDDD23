extends TextureButton

onready var label = get_node("Label")
onready var background = get_node("background")
onready var disablePanel = get_node("Panel")
onready var test = get_node("test")
onready var test2 = get_node("test2")

func _process(delta):
	if pressed:
		background.show()
		release_focus()
	else:
		background.hide()

func _ready():
	background.hide()
	label.hide()
	print(background)
	print(label)
	print("Test: ",test)
	print("Test2: ",test2)
	update_label(2)

func update_label(damage):
		var new_text = "Main Attack \n Fires a projectile infront of the player. \n Leveling up increases damage done."
#		ªvar new_text2 = new_text % [String(damage)]
		label.set_text(new_text)

func _on_mainAttackButton_mouse_entered():
	label.show()

func _on_mainAttackButton_mouse_exited():
	label.hide()
