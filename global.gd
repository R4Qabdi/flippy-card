extends Node

var playerpoint = 0
#var cards_in_deck_name = [
  #"AS","2S","3S","4S","5S","6S","7S","8S","9S","10S","JS","QS","KS",
  #"AH","2H","3H","4H","5H","6H","7H","8H","9H","10H","JH","QH","KH",
  #"AD","2D","3D","4D","5D","6D","7D","8D","9D","10D","JD","QD","KD",
  #"AC","2C","3C","4C","5C","6C","7C","8C","9C","10C","JC","QC","KC"
#]
var cards_in_deck_id = [
	1,2,3,4,5,6,7,8,9,10,11,12,13,
	14,15,16,17,18,19,20,21,22,23,24,25,26,
	27,28,29,30,31,32,33,34,35,36,37,38,39,
	40,41,42,43,44,45,46,47,48,49,50,51,52
]
var playerhand=[]
var opphand=[]

var fullscreen = false

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		fullscreen = not fullscreen
		toggle_fullscreen()

func toggle_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
