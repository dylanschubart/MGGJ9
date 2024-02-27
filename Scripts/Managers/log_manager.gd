extends Node

var current_char = 0
var full_log = ""
var message: String
var display = "\n"

func write_to_log(text:String):
	if !Ui.next_char_timer.is_connected("timeout", _on_timer_timeout):
		Ui.next_char_timer.connect("timeout", _on_timer_timeout)
		
	message = text
	
	if current_char < len(message):
		
		var next_char = message[current_char]
		print_debug(next_char)
		display = display + next_char
		current_char =  current_char + 1
		#print_debug("next_char %s" % next_char)
		#print_debug("display %s" % display)
		print_debug("current_char %s" % current_char)
		Ui.next_char_timer.start()
		#full_log = full_log + display
	Ui.log_rich_text.text = display
	
	
	
		
func _on_timer_timeout() -> void:
	#
	if current_char == len(message):
		full_log = full_log + display
		current_char = 0
		display = "\n"
		return
	else:
		print_debug("time out, write_to_log")
		write_to_log(message)
