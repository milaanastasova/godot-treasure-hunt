extends Node3D

@onready var treasure_label: Label = $CanvasLayer/Control/TreasuresLeftLabel
@onready var timer_label: Label = $CanvasLayer/Control/TimerLabel
@onready var timer: Timer = $Timer
@onready var game_over_screen: ColorRect = $CanvasLayer/Control/GameOverScreen
@onready var game_over_label: Label = $CanvasLayer/Control/GameOverScreen/GameOverLabel
@onready var player: CharacterBody3D = $PlayerController

var total_treasures: int = 0
var time_left: int = 60
var game_over_flag: bool = false
var treasure_positions = []  # Stores original treasure positions
var treasure_scene: PackedScene  # Stores the treasure scene
var player_start_position: Vector3

func _ready():
	print("Game script is ready.")

	# Validate nodes
	if not timer or not timer_label or not treasure_label or not game_over_screen or not game_over_label or not player:
		print("Error: Missing required nodes!")
		return

	player_start_position = player.global_position
	print("Player start position:", player_start_position)

	game_over_screen.visible = false

	# Load treasure scene from an existing instance
	var treasures = get_tree().get_nodes_in_group("treasures")
	if treasures.size() > 0:
		treasure_scene = load(treasures[0].scene_file_path)  # Get scene from first treasure

	# Store original positions
	for treasure in treasures:
		treasure_positions.append(treasure.global_position)
		treasure.connect("treasure_collected", _on_treasure_collected)

	# Set total treasures
	total_treasures = treasure_positions.size()
	update_treasure_label()
	update_timer_label()
	timer.timeout.connect(_on_Timer_timeout)
	timer.start()
	print("Timer started with", time_left, "seconds.")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		restart_game()

func _on_treasure_collected():
	if game_over_flag:
		return

	total_treasures -= 1
	update_treasure_label()

	if total_treasures == 0:
		game_over("Победивте! Притиснете [R] за нова игра")

func update_treasure_label():
	treasure_label.text = "Најдени богатства: " + str(len(treasure_positions) - total_treasures) + "/" + str(len(treasure_positions))

func _on_Timer_timeout():
	if game_over_flag:
		return

	time_left -= 1
	update_timer_label()
	print("Преостанато време:", time_left)

	if time_left <= 0:
		game_over("Изгубивте! Притисните [R] за нова игра")

func update_timer_label():
	timer_label.text = "Преостанато време: " + str(time_left)

func game_over(message: String):
	game_over_flag = true
	timer.stop()
	print("Game Over:", message)

	game_over_screen.visible = true
	game_over_label.text = message

func restart_game():
	print("\n--- Restarting game ---")

	# Hide game over screen
	game_over_screen.visible = false
	game_over_flag = false

	# Reset timer
	time_left = 60
	update_timer_label()
	timer.start()

	# Reset player position
	if player:
		player.global_position = player_start_position
		player.velocity = Vector3.ZERO
		print("Player position reset:", player_start_position)
	else:
		print("Error: Player node is missing!")

	# **Clear old treasures and reset the treasure count**
	var existing_treasures = get_tree().get_nodes_in_group("treasures")
	print("Removing old treasures:", existing_treasures.size())
	for treasure in existing_treasures:
		treasure.queue_free()

	# Reset treasure count
	total_treasures = 3  # Reset total treasures back to 3
	print("🔄 Reset total treasures to:", total_treasures)

	# **Respawn treasures**
	print("Respawning treasures...")
	for pos in treasure_positions:
		var new_treasure = treasure_scene.instantiate()
		add_child(new_treasure)
		new_treasure.global_position = pos
		new_treasure.add_to_group("treasures")  # Ensure it's in the group

		# Reconnect the treasure collection signal
		new_treasure.connect("treasure_collected", _on_treasure_collected)

	# **Reset the treasure label and UI**
	update_treasure_label()

	# **Reset the timer label to show the starting time**
	update_timer_label()

	print("UI updated. Total treasures after restart:", total_treasures)

	print("--- Game restarted successfully! ---\n")


	update_treasure_label()
