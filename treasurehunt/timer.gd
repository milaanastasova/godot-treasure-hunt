extends Node3D

@onready var label: Label = $CanvasLayer/Control/TimerLabel  # Path to the Label
@onready var timer: Timer = $Timer  # Path to the Timer

var time_left: int = 30  # Timer starts at 30 seconds

func _ready():
	# Print to the console when the timer script is ready and running
	print("Timer script is ready and starting.")

	if not timer:
		print("Error: Timer node not found!")
		return
	
	if not label:
		print("Error: Label node not found!")
		return

	update_timer_label()
	timer.timeout.connect(_on_Timer_timeout)  # Connect the Timer signal
	timer.start()  # Start the countdown
	print("Timer started.")  # Log that the timer has started

func _on_Timer_timeout():
	print("Timer timeout reached.")  # Log every time the timer times out

	time_left -= 1
	update_timer_label()

	if time_left <= 0:
		game_over()

func update_timer_label():
	label.text = "Time: " + str(time_left)

func game_over():
	label.text = "Time's up!"
	print("Game over!")  # Log game over message
	timer.stop()  # Stop the countdown
