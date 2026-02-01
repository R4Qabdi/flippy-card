extends Node2D

signal hover
signal hover_exit
@export var id:int
@export var is_facing_up:bool = true
var selectable:bool

const CARD_DATA = {
	"0": {"name": null, "suit":null, "color":null, "value":0},
	"1": { "name": "ah", "suit": "heart", "color": "red", "value": 11 },
	"2": { "name": "2h", "suit": "heart", "color": "red", "value": 2 },
	"3": { "name": "3h", "suit": "heart", "color": "red", "value": 3 },
	"4": { "name": "4h", "suit": "heart", "color": "red", "value": 4 },
	"5": { "name": "5h", "suit": "heart", "color": "red", "value": 5 },
	"6": { "name": "6h", "suit": "heart", "color": "red", "value": 6 },
	"7": { "name": "7h", "suit": "heart", "color": "red", "value": 7 },
	"8": { "name": "8h", "suit": "heart", "color": "red", "value": 8 },
	"9": { "name": "9h", "suit": "heart", "color": "red", "value": 9 },
	"10": { "name": "10h", "suit": "heart", "color": "red", "value": 10 },
	"11": { "name": "jh", "suit":  "heart", "color": "red", "value": 10 },
	"12": { "name": "qh", "suit":  "heart", "color": "red", "value": 10 },
	"13": { "name": "kh", "suit":  "heart", "color": "red", "value": 10 },

	"14": { "name": "ad", "suit": "diamond", "color": "red", "value": 11 },
	"15": { "name": "2d", "suit": "diamond", "color": "red", "value": 2 },
	"16": { "name": "3d", "suit": "diamond", "color": "red", "value": 3 },
	"17": { "name": "4d", "suit": "diamond", "color": "red", "value": 4 },
	"18": { "name": "5d", "suit": "diamond", "color": "red", "value": 5 },
	"19": { "name": "6d", "suit": "diamond", "color": "red", "value": 6 },
	"20": { "name": "7d", "suit": "diamond", "color": "red", "value": 7 },
	"21": { "name": "8d", "suit": "diamond", "color": "red", "value": 8 },
	"22": { "name": "9d", "suit": "diamond", "color": "red", "value": 9 },
	"23": { "name":"10d", "suit": "diamond", "color": "red", "value": 10 },
	"24": { "name": "jd", "suit": "diamond", "color": "red", "value": 10 },
	"25": { "name": "qd", "suit": "diamond", "color": "red", "value": 10 },
	"26": { "name": "kd", "suit": "diamond", "color": "red", "value": 10 },

	"27": { "name": "ac","suit": "club", "color": "black", "value": 11 },
	"28": { "name": "2c","suit": "club", "color": "black", "value": 2 },
	"29": { "name": "3c","suit": "club", "color": "black", "value": 3 },
	"30": { "name": "4c","suit": "club", "color": "black", "value": 4 },
	"31": { "name": "5c","suit": "club", "color": "black", "value": 5 },
	"32": { "name": "6c","suit": "club", "color": "black", "value": 6 },
	"33": { "name": "7c","suit": "club", "color": "black", "value": 7 },
	"34": { "name": "8c","suit": "club", "color": "black", "value": 8 },
	"35": { "name": "9c","suit": "club", "color": "black", "value": 9 },
	"36": { "name":"10c", "suit":"club", "color": "black", "value": 10 },
	"37": { "name": "jc","suit": "club", "color": "black", "value": 10 },
	"38": { "name": "qc","suit": "club", "color": "black", "value": 10 },
	"39": { "name": "kc","suit": "club", "color": "black", "value": 10 },

	"40": { "name": "as","suit": "spade", "color": "black", "value": 11 },
	"41": { "name": "2s","suit": "spade", "color": "black", "value": 2 },
	"42": { "name": "3s","suit": "spade", "color": "black", "value": 3 },
	"43": { "name": "4s","suit": "spade", "color": "black", "value": 4 },
	"44": { "name": "5s","suit": "spade", "color": "black", "value": 5 },
	"45": { "name": "6s","suit": "spade", "color": "black", "value": 6 },
	"46": { "name": "7s","suit": "spade", "color": "black", "value": 7 },
	"47": { "name": "8s","suit": "spade", "color": "black", "value": 8 },
	"48": { "name": "9s","suit": "spade", "color": "black", "value": 9 },
	"49": { "name":"10s","suit": "spade", "color": "black", "value": 10 },
	"50": { "name": "js","suit": "spade", "color": "black", "value": 10 },
	"51": { "name": "qs","suit": "spade", "color": "black", "value": 10 },
	"52": { "name": "ks","suit": "spade", "color": "black", "value": 10 },

	"53": { "name": "joker_black", "suit": "joker", "color": "black", "value": 0 },
	"54": { "name": "joker_red", "suit": "joker", "color": "red", "value": 0 }
	}


func _ready() -> void:
	$textures.frame = id
	if !is_facing_up:
		$textures.frame = 55
	get_parent().connect_card_signals(self)
	print(CARD_DATA[str(id)]["value"])

func _on_area_2d_mouse_entered() -> void:
	if selectable:
		$textures/hover.visible = true
		emit_signal("hover", self)

func _on_area_2d_mouse_exited() -> void:
	if selectable:
		$textures/hover.visible = false
		emit_signal("hover_exit", self)

func change_facing():
	is_facing_up = !is_facing_up
	if is_facing_up:
		$textures.frame = id
	else:
		$textures.frame = 55
