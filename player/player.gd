extends KinematicBody2D

signal death
signal restart

const PRELOAD_BULLET = preload("res://bullets/standart/bullet.tscn")

var max_health = 100
var health = max_health
var weapon_damage = 30
var accelerate = 100
var max_speed = 32
var scoup = 0
var expiriance = 0
var level = 0

export var next_level_expirience = 1000
onready var this_level_expiriance = 0.0001
var next = 1000

var velocity = Vector2(0,-1)
var moving = false
var dead = false

func _ready():
	
	pass

func _process(delta):
	
	
	if dead:
		velocity = Vector2(0,0)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.normal)
	velocity = move_and_slide(velocity, Vector2.UP) 
	
	velocity -= velocity*0.2
		
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	if velocity.y > max_speed:
		velocity.y = max_speed
	elif velocity.y < -max_speed:
		velocity.y = -max_speed
	
	
	#print(expiriance)
	
	get_input()

func get_input():
	moving = false
	if Input.is_action_pressed("W"):
		if velocity.x != 0:
			velocity.y -= accelerate/1.41
		else:
			velocity.y -= accelerate
		moving = true
	if Input.is_action_pressed("S"):
		if Input.is_action_pressed("D") or Input.is_action_pressed("A"):
			velocity.y += accelerate/1.41
		else:
			velocity.y += accelerate
		moving = true
	if Input.is_action_pressed("A"):
		if Input.is_action_pressed("S") or Input.is_action_pressed("W"):
			velocity.x -= accelerate/1.41
		else:
			velocity.x -= accelerate
		moving = true
	if Input.is_action_pressed("D"):
		if Input.is_action_pressed("S") or Input.is_action_pressed("W"):
			velocity.x += accelerate/1.41
		else:
			velocity.x += accelerate
		moving = true

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		var direction = position.direction_to(event.position - Vector2(500, 300) + position)
		var node_bullet = PRELOAD_BULLET.instance()
		get_parent().add_child(node_bullet)
		
		node_bullet.position = position
		node_bullet.velocity = direction*400 + velocity
		

func hit(damage):
	if health > damage:
		health -= damage
	elif health <= damage:
		health = 0
		emit_signal("death")
		dead = true
		$on_death.visible = true


func _on_respawn_pressed():
	emit_signal("restart")
	get_tree().change_scene_to(load("res://test.tscn"))
	dead = false
	$on_death.visible = false


func _on_Timer_timeout():
	if !dead:
		scoup += 1
	$scoup.text = str(scoup)

func expirience_Area_body_entered(body):
	if body.test() == "exp":
		print(expiriance)
		expiriance += body.number()

	$ExpBar.value = expiriance
	
	if $ExpBar.value >= $ExpBar.max_value:
		expiriance = 0
		$ExpBar.value = 0
		$ExpBar.max_value = $ExpBar.max_value*1.5

		print("level_up")
#		print("level_up")
#func update_exp():
#	$ExpBar.value = expiriance
	

#func expirience_Area_body_entered(body):
#	if body.test() == "exp":
#		print(expiriance)
#		expiriance += body.number()
#		$level_progress.value = (expiriance-this_level_expiriance)/(next_level_expirience-this_level_expiriance)*100
#		if expiriance >= next_level_expirience:
#			this_level_expiriance = next_level_expirience
#			next_level_expirience += next
#			next += 100
#			level += 1
#			print("level_up")

func test():
	return "player"


func _on_ExpBar_value_changed(value):
	value = $ExpBar.value
	if $ExpBar.value >= $ExpBar.max_value:
		value = 0
	

	
	
