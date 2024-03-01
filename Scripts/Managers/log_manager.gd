extends Node

var current_char = 0
var full_log = ""
var message: String
var formatted_text = "\n"

func write_to_log(text:String):
	#if !Ui.next_char_timer.is_connected("timeout", _on_timer_timeout):
		#Ui.next_char_timer.connect("timeout", _on_timer_timeout)
		#
	#message = text
	#
	#if current_char < len(message):
		#
		#var next_char = message[current_char]
		#print_debug(next_char)
		#formatted_text = formatted_text + next_char
		#current_char =  current_char + 1
		#print_debug("current_char %s" % current_char)
		#Ui.next_char_timer.start()
		#full_log + formatted_text
	#Ui.log_rich_text.text = formatted_text
	formatted_text = "\n"
	formatted_text = formatted_text + text
	Ui.log_rich_text.text = Ui.log_rich_text.text + formatted_text
	
	
		
func _on_timer_timeout() -> void:
	#
	if current_char == len(message):
		full_log = full_log + formatted_text
		current_char = 0
		formatted_text = "\n"
		return
	else:
		print_debug("time out, write_to_log")
		write_to_log(message)
