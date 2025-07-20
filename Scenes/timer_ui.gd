extends Control

@onready var timer_label = $TimerLabel

var elapsed_time = 0.0  # Time in seconds since game start

func _ready():
	# Initialize label
	timer_label.text = "00:00"

func _process(delta):
	# Update elapsed time
	elapsed_time += delta
	# Format as MM:SS
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
