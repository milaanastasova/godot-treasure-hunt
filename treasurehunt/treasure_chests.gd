#extends Node3D
#
## Timer-related variables
#@onready var label: Label = $CanvasLayer/Control/TimerLabel  # Path to the Label
#@onready var timer: Timer = $Timer  # Path to the Timer
#
#var time_left: int = 30  # Timer starts at 30 seconds
#
#func _ready():
	#print("Game script is ready and starting.")
#
	## Check if timer and label exist
	#if not timer or not label:
		#print("Error: Timer or Label node not found!")
		#return
#
	## Initialize Timer
	#update_timer_label()
	#timer.timeout.connect(_on_Timer_timeout)
	#timer.start()
	#print("Timer started.")
#
## Timer function that triggers every second
#func _on_Timer_timeout():
	#print("Timer tick. Time left:", time_left)
#
	#time_left -= 1
	#update_timer_label()
#
	#if time_left <= 0:
		#game_over()
#
## Function to update the timer label
#func update_timer_label():
	#label.text = "Time: " + str(time_left)
#
## Function that gets triggered when time runs out
#func game_over():
	#label.text = "Time's up!"
	#print("Game over!")  # Log game over message
	#timer.stop()  # Stop the countdown
