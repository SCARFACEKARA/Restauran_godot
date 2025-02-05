extends Node

@onready var http_request = $HTTPRequest  # Référence au nœud HTTPRequest

# URL de base de l'API
var base_url = "http://192.168.1.173:8000/api/users/login"

# Fonction pour envoyer une requête GET
func get_data(endpoint: String) -> void:
	var url = base_url + endpoint
	print("Envoi de la requête GET à :", url)
	
	var error = http_request.request(url)
	if error != OK:
		print("Erreur lors de l'envoi de la requête GET :", error)

# Fonction pour envoyer une requête POST avec des données JSON
func post_data(endpoint: String, data: Dictionary) -> void:
	var url = base_url + endpoint
	print("Envoi de la requête POST à :", url)
	
	# Convertir les données en JSON
	var json_data = JSON.stringify(data)
	
	# Headers pour indiquer qu'on envoie du JSON
	var headers = ["Content-Type: application/json"]
	
	# Envoi de la requête POST
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
	if error != OK:
		print("Erreur lors de l'envoi de la requête POST :", error)

# Fonction appelée lorsque la requête est terminée
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:  # Vérifie si la requête a réussi
		var response_text = body.get_string_from_utf8()  # Convertir en texte
		var json = JSON.parse_string(response_text)  # Parser le JSON
		
		if json:
			print("Données reçues :", json)
			emit_signal("request_completed", json)  # Émettre un signal avec les données
		else:
			print("Erreur de parsing JSON")
			emit_signal("request_failed", "Erreur de parsing JSON")
	else:
		print("Erreur de requête, code :", response_code)
		emit_signal("request_failed", "Erreur de requête, code : " + str(response_code))

# Signaux pour gérer les résultats des requêtes
signal request_completed(data)
signal request_failed(error_message)

func _ready() -> void:
	http_request.request_completed.connect(_on_http_request_request_completed)  # Connecter le signal de réponse
