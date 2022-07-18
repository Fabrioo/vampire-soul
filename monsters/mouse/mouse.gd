extends KinematicBody2D

signal death


var uron = 50

var health = 50
var velocity = Vector2(0,0)
var dead = false

var run_speed = 55


func _physics_process(delta):
	velocity = Vector2.ZERO
	if !dead:
		var player = get_parent().get_node("player")
		velocity = position.direction_to(player.position) * run_speed
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)



func _on_Area2D_body_entered(body):
	if body.name == "player" and !dead:
		body.hit(uron)

func hit(damage):
	if health > damage:
		health -= damage
	else:
		emit_signal("death")
		dead = true
		$CollisionShape2D.disabled = true
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()

func test():
	return "monster"
