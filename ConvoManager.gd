extends Node

var vampire_dialog = ["suck me off"]
var ghost_dialog = ["you're super haunt"]
var skeleton_dialog = ["wanna bone"]

var convos = {
	"eat_chips": {
		"text" : "there's some nacho chips and dips here",
		"options": [
			{"text" : "eat chip with guacamole", "send_to": "ate_guac", "set_state": "ate_garlic"},
			{"text" : "eat chip with salsa", "send_to": "ate_salsa"},
			{"text" : "eat chip with hummus", "send_to": "ate_hummus"}
		]
	},
	"ate_guac": {
		"text" : "yuck! too much garlic",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"ate_salsa": {
		"text" : "it's pretty much just tomatoes and corn",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"ate_hummus": {
		"text" : "perfectly spiced, very mediterranean",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"talk_to_dog": {
		"text": "it's a dog, it's here to be pet",
		"options": [
			{"text": "pet", "send_to": "pet_dog"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"pet_dog" :{
		"text": "the dog recieves your pet and seems pleased",
		"options": [
			{"text": "pet", "send_to": "pet_dog"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"talk_to_dog_with_skeleton": {
		"text": "the dog notices some tasty bones...\nSkeleton: ....uhhh",
		"options": [
			{"text" : "Bye", "send_to": "close", "set_state": "dog_chase_skeleton"}
		]
	},
	"talk_to_vampire_after_eating_garlic": {
		"text": "Hey baby how you... ugh what is that awful smell?! \nWatch what you eat if you want guys to like you...",
		"options": [
			{"text" : "Bye", "send_to": "close", "set_state": "garlic_chase_vampire"}
		]
	},
}

func display_dialog(id):
	$TextDisplay.text = convos.id.text
	for option in convos.id.options:
		pass

func pick_random_dialog(dialog_list):
	return dialog_list[randi() % dialog_list.size()]