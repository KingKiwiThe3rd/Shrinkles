extends Control

@onready var timer_label = $TimerLabel

var elapsed_time = 0.0  # Time in seconds since game start

func _ready():
	# Initialize label
	timer_label.text = "00:00"

func _process(delta):
	timer_label.text = TimerManager.get_formatted_time()
