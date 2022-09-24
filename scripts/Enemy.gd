extends RigidBody2D

export var health = 100

func reduce_health(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
