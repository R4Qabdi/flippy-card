extends Node

@onready var musik = $music
@onready var sfx = $sfx

const bgm = preload("res://asset/sounds/Story For Money #19 - Orchestrated.WAV")

const boom = preload("res://asset/sounds/boom.wav")
const coin = preload("res://asset/sounds/coin.wav")
const select = preload("res://asset/sounds/select.wav")
const slide = preload("res://asset/sounds/slide.wav")

func play_sound(sound):
	match sound:
		"boom":
			sfx.stream = boom
		"coin":
			sfx.stream = coin
		"select":
			sfx.stream = select
		"slide":
			sfx.stream = slide
	sfx.play()

func _ready() -> void:pass
