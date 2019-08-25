extends KinematicBody2D

signal playerShoot(bullet, position, direction, damage)
signal playerCanShoot()
signal toggleStonePressed(stoneKeyPressed)
signal toggleTowerPressed(towerKeyPressed)
signal placeFeature(featureScene, clickPosition)
signal xpUpdate(xpData)
signal disableTower()
signal disableStone()
signal enableTower()
signal enableStone()

export (int) var speed = 200

var velocity = Vector2()
onready var bulletScene = load("res://Scenes/bullet_test_2.tscn")
onready var stoneScene = load("res://Scenes/stone.tscn")
onready var towerScene = load("res://Scenes/tower.tscn")

onready var stoneKeyPressed = false
onready var stoneDisabled = false
onready var towerKeyPressed = false
onready var towerDisabled = true
onready var canShoot = true
onready var shootTimer = get_node("shootTimer")
onready var level = 1
onready var xpRequired = 5
onready var xp = 0
onready var availableStones = 3
onready var stonesPlaced = 0
onready var availableTowers = 0
onready var towersPlaced = 0
onready var attackDamage = 2

func _ready():
	var xpData = [level, xp, xpRequired] 
	emit_signal("xpUpdate", xpData)

func get_input():
	velocity = Vector2()
	look_at(get_global_mouse_position())
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.get_button_index() == 1:
			left_mouse_pressed(event.position)
		if event.get_button_index() == 2:
			if stoneKeyPressed:
				stoneKeyPressed = false
				emit_signal("toggleStonePressed", stoneKeyPressed)
			if towerKeyPressed:
				towerKeyPressed = false
				emit_signal("toggleTowerPressed", towerKeyPressed)
	if event is InputEventKey:
		if event.scancode == KEY_1 and event.pressed:
			if not towerDisabled:
				towerKeyPressed = !towerKeyPressed
				stoneKeyPressed = false
				emit_signal("toggleTowerPressed", towerKeyPressed)
				emit_signal("toggleStonePressed", stoneKeyPressed)
		if event.scancode == KEY_2 and event.pressed:
			if not stoneDisabled:
				stoneKeyPressed = !stoneKeyPressed
				towerKeyPressed = false
				emit_signal("toggleStonePressed", stoneKeyPressed)
				emit_signal("toggleTowerPressed", towerKeyPressed)



func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
func left_mouse_pressed(clickPosition):
	if stoneKeyPressed:
		stonesPlaced += 1
		emit_signal("placeFeature", stoneScene, clickPosition)
		if stonesPlaced >= availableStones:
			stoneDisabled = true
			stoneKeyPressed = false
			print("Emited stone disable signal!")
			emit_signal("disableStone")
	elif towerKeyPressed:
		towersPlaced += 1
		emit_signal("placeFeature", towerScene, clickPosition)
		if towersPlaced >= availableTowers:
			towerDisabled = true
			towerKeyPressed = false
			emit_signal("disableTower")
	elif canShoot:
		canShoot = false
		shootTimer.start()
		var direction = Vector2(1,0).rotated(global_rotation)
		emit_signal("playerShoot", bulletScene, position, direction, attackDamage)

func _on_shootTimer_timeout():
	canShoot = true
	emit_signal("playerCanShoot")

func _on_mob_died():
	xp += 1
	if xp > xpRequired:
		player_level_up()
	var xpData = [level, xp, xpRequired]
	emit_signal("xpUpdate", xpData)

func player_level_up():
	xp = 0
	xpRequired += 5
	level += 1
	availableStones += 3

	print("Level up! New level: ", level)
	if stoneDisabled:
		stoneDisabled = false
		emit_signal("enableStone")
	if level == 3:
		attackDamage = 3
	if level == 8:
		attackDamage = 6
	
	if (level % 2) == 0:
		availableTowers += 1
		if towerDisabled:
			towerDisabled = false
			emit_signal("enableTower")