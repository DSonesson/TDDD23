extends ProgressBar

var currentLevel = 1
var nextLevel = currentLevel+1

onready var currentLevelLabel = get_node("blue_circle/currentLevelLabel")
onready var nextLevelLabel = get_node("red_circle/nextLevelLabel")
onready var infoLabel = get_node("Label")

func _on_player_xpUpdate(xpData):
	currentLevel = xpData[0]
	nextLevel = currentLevel+1
	value = xpData[1]
	max_value = xpData[2]
	print("xpBar current level: ", currentLevel)
	currentLevelLabel.set_text(String(currentLevel))
	nextLevelLabel.set_text(String(nextLevel))
	var infoText = "Current level %s \n Current XP: %s \n XP required to level: %s"
	infoText = infoText % [String(currentLevel), String(value), String(max_value)]
	infoLabel.set_text(infoText)

func _on_xpBar_mouse_entered():
	infoLabel.show()
	
func _on_xpBar_mouse_exited():
	infoLabel.hide()
