extends Node3D

@onready var treasure_label: Label = $CanvasLayer/Control/TreasuresLeftLabel  # Treasures label
@onready var timer_label: Label = $CanvasLayer/Control/TimerLabel  # Timer label
@onready var timer: Timer = $Timer  # Timer node
@onready var game_over_screen: ColorRect = $CanvasLayer/Control/GameOverScreen  # Black overlay
@onready var game_over_label: Label = $CanvasLayer/Control/GameOverScreen/GameOverLabel  # Game over text

var total_treasures: int = 0  # Total treasures
var time_left: int = 60  # Timer starts at 30 seconds
var game_over_flag: bool = false  # Flag to prevent interactions after game ends

func _ready():
	print("Game script is ready.")  # Debugging

	# Ensure all required nodes exist
	if not timer or not timer_label or not treasure_label or not game_over_screen or not game_over_label:
		print("Error: Missing required nodes!")
		return

	# Hide the game over screen initially
	game_over_screen.visible = false

	# Get all treasures and update count
	var treasures = get_tree().get_nodes_in_group("treasures")
	total_treasures = treasures.size()
	update_treasure_label()

	# Connect treasures to event
	for treasure in treasures:
		treasure.connect("treasure_collected", _on_treasure_collected)

	# Start the timer countdown
	update_timer_label()
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	print("Timer started with", time_left, "seconds.")  # Debugging

# **Treasure Handling**
func _on_treasure_collected():
	if game_over_flag:
		return  # Prevent collection after game over

	total_treasures -= 1
	update_treasure_label()

	if total_treasures == 0:
		game_over("GAME WON!")

func update_treasure_label():
	treasure_label.text = "Treasures Left: " + str(total_treasures)

# **Timer Handling**
func _on_Timer_timeout():
	if game_over_flag:
		return  # Stop updating if game is over

	time_left -= 1
	update_timer_label()
	print("Time left:", time_left)  # Debugging

	if time_left <= 0:
		game_over("GAME LOST!")

func update_timer_label():
	timer_label.text = "Time: " + str(time_left)

# **Game Over Logic**
func game_over(message: String):
	game_over_flag = true
	timer.stop()  # Stop timer
	print("Game Over:", message)  # Debugging
	
	# Show the game over screen
	game_over_screen.visible = true
	game_over_label.text = message
