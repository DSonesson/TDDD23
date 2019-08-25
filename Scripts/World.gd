extends Node

signal map_update

var mob  = preload("res://Scenes/fire_mob.tscn")

onready var nav = get_node("nav")
onready var map = get_node("nav/map")
onready var tower = get_node("Tower")
onready var start_pos1 = get_node("start_pos1")
onready var start_pos2 = get_node("start_pos2")
onready var start_pos3 = get_node("start_pos3")
onready var start_pos4 = get_node("start_pos4")
onready var end_pos = get_node("end_pos")
onready var mob_timer = get_node("mob_timer")
onready var mainAttackButton = get_node("NinePatchRect/mainAttackButton")
onready var waveStartButton = get_node("NinePatchRect/waveStartButton")
onready var towerButton = get_node("NinePatchRect/towerButton")
onready var stoneButton = get_node("NinePatchRect/stoneButton")
onready var finishedLabel = get_node("finishedLabel")
onready var redGreeedMap = get_node("nav/redGreenMap")
onready var player = get_node("player")
onready var fire = get_node("end_pos/playerHouse/fire")
onready var fire2 = get_node("end_pos/playerHouse/fire2")
onready var fire3 = get_node("end_pos/playerHouse/fire3")
onready var fire4 = get_node("end_pos/playerHouse/fire4")
onready var fire5 = get_node("end_pos/playerHouse/fire5")
onready var fire6 = get_node("end_pos/playerHouse/fire6")
onready var defeatLabel = get_node("defeatLabel")
onready var houseLabel = get_node("end_pos/Control/Label")
onready var startLabel = get_node("startLabel")

var clicked_tower = null

var clickedTowerSprite
var prevMouseTile = Vector2(0,0)
var invalidTiles = []
var validTiles = [Vector2()]
var startPositions = []
var rng = RandomNumberGenerator.new()
var waveActive = false
var activeMobCount = 0
var waveSize = 3
var tmpWaveSize
var waveNo = 1
var houseHP = 15
var startText = "Press Space to start wave %s"

func _ready():
	rng.randomize()
	startPositions = [start_pos1, start_pos2, start_pos3, start_pos4]
	for y in range(9):
		if y > 0  and y < 9:
			for x in range(17):
				if x > 0 and x < 17:
					validTiles.append(Vector2(x,y))
	print("Back valid tile: ", validTiles.back())
	set_process_input(true)
	var startTextTmp = startText % [waveNo]
	startLabel.set_text(startTextTmp)

func _process(delta):
	#Visar grön/Röd tile när man hovrar över på mapen.
	if stoneButton.pressed or towerButton.pressed:
		var tile = map.world_to_map(get_viewport().get_mouse_position())
		var tileNo = 0
		if not tile in validTiles: #Då visar den rött
			tileNo = 1
		redGreeedMap.set_cell(tile.x, tile.y, tileNo)
		if prevMouseTile.x != tile.x or prevMouseTile.y != tile.y:
			redGreeedMap.set_cell(prevMouseTile.x, prevMouseTile.y, -1)
		prevMouseTile = tile

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE and event.pressed:
			start_mob_wave()

func update_mob_paths():
	var mobs = get_tree().get_nodes_in_group("mobs")
	for mob in mobs:
		mob.update_path()

func _on_mob_timer_timeout():
	print("Mobtimer timeout!")
	var start_position = startPositions[rng.randi_range(0,3)]
	if tmpWaveSize > 0:
		var m = mob.instance()
		add_child(m)
		connect("map_update", m, "update_path")
		m.add_to_group("mobs")
		m.goal = end_pos.position
		m.nav = nav
		m.position = start_position.position
		m.connect("mob_died", player, "_on_mob_died")
		m.connect("mob_died", self, "_on_mob_died")
		m.connect("reached_goal", self, "_om_mob_reached_goal")
		m.update_path()
		tmpWaveSize -= 1
	else: #Wave complete
		waveActive = false
		mob_timer.stop()
		waveSize += 2

func _on_mob_died():
	if not waveActive:
		if get_tree().get_nodes_in_group("mobs").size() == 0:
			waveStartButton.disabled = false
			var startTextTmp = startText % [waveNo] 
			startLabel.set_text(startTextTmp)
			startLabel.show()

func _om_mob_reached_goal():
	houseHP -= 1
	if not waveActive:
		if get_tree().get_nodes_in_group("mobs").size() == 0:
			waveStartButton.disabled = false
			startLabel.show()
	if houseHP == 12:
		fire.show()
	if houseHP == 8:
		fire2.show()
	if houseHP == 6:
		fire3.show()
	if houseHP == 4:
		fire4.show()
	if houseHP == 2:
		fire5.show()
	if houseHP == 0:
		fire6.show()
		defeatLabel.show()
		startLabel.hide()

func start_mob_wave():
	tmpWaveSize = waveSize
	startLabel.hide()
	waveActive = true
	waveNo += 1
	mob_timer.start()
	waveStartButton.disabled=true

func _on_player_playerShoot(bullet, position, direction, damage):
	var tile = map.world_to_map(get_viewport().get_mouse_position())
	print(tile)
	mainAttackButton.pressed = true
	var b = bullet.instance()
	b.direction = direction
	b.position = position
	b.damage = damage
	add_child(b)

func _on_player_placeFeature(featureScene, clickPosition):
	var tile = map.world_to_map(clickPosition)
	if tile in validTiles:
		validTiles.erase(Vector2(tile.x, tile.y))
		map.set_cell(tile.x, tile.y, 6)
		var tilePosition = map.map_to_world(tile)
		var feature = featureScene.instance()
		feature.set_name("feature"+str(tilePosition.x)+str(tilePosition.y))
		feature.set_global_position(Vector2(tilePosition.x+32,tilePosition.y+32))
		add_child(feature)
		update_mob_paths()

func _on_player_playerCanShoot():
	mainAttackButton.pressed = false

func _on_player_toggleStonePressed(stoneKeyPressed):
	stoneButton.pressed = stoneKeyPressed

func _on_player_toggleTowerPressed(towerKeyPressed):
	towerButton.pressed = towerKeyPressed

func _on_player_disableStone():
	stoneButton.disableButton()

func _on_player_disableTower():
	towerButton.disableButton()

func _on_player_enableStone():
	stoneButton.enableButton()

func _on_player_enableTower():
	towerButton.enableButton()


func _on_Control_mouse_entered():
	var houseText = "Player House! \n HP %s/15"
	houseText = houseText % [String(houseHP)]
	houseLabel.set_text(houseText)
	houseLabel.show()


func _on_Control_mouse_exited():
	houseLabel.hide()
