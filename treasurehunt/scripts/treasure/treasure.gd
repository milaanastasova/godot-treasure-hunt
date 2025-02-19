extends Area3D

const ROT_SPEED = 2 # number of degrees the coin rotates every frame

signal treasure_collected  # Declare the signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

	#if has_overlapping_bodies():
		#queue_free()

func _on_body_entered(body: Node3D) -> void:
	emit_signal("treasure_collected")
	queue_free()
