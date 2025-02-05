extends Control

@onready var button_post = $ButtonPost

var url = "http://172.90.26.220:8000/api/admin/ingredients/all"
var ingredients_text = ""
var post_data = {"ingredient": "Carrot"}

func _ready():
	button_post.text = "Envoyer un ingrédient"
	button_post.pressed.connect(send_ingredient)

func send_ingredient():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_post_request_completed)
	
	# Convertir les données en JSON
	var json_data = JSON.stringify(post_data)
	
	# Définir les en-têtes HTTP (Content-Type pour JSON)
	var headers = ["Content-Type: application/json"]
	
	# Envoi de la requête POST avec les en-têtes et le corps JSON
	var error = http_request.request(url, headers,  HTTPClient.METHOD_POST ,json_data)
	
	if error != OK:
		print("Erreur lors de la requête")

func _on_post_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Données envoyées avec succès !")
		print("Réponse du serveur : ", body.get_string_from_utf8())
	else:
		print("Erreur HTTP : ", response_code)
