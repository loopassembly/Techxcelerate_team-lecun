import cv2
import numpy as np
import insightface
from insightface.app import FaceAnalysis
from sklearn.metrics.pairwise import cosine_similarity
import os

# Initialize the face analysis application (using CPU)
app = FaceAnalysis(providers=['CPUExecutionProvider'])
app.prepare(ctx_id=0, det_size=(640, 640))

# Directory to store uploaded images
uploaded_images_path = "C:/Users/AMOGH/OneDrive/Desktop/Photo Verification 2/Uploaded_Images"
known_face_embeddings = []
known_face_names = []

# Normalize the embedding vector
def normalize(embedding):
    norm = np.linalg.norm(embedding)
    if norm == 0:
        return embedding  # Prevent division by zero
    return embedding / norm

# Calculate cosine similarity
def cosine_similarity_score(embedding1, embedding2):
    embedding1 = normalize(embedding1)
    embedding2 = normalize(embedding2)
    similarity = cosine_similarity([embedding1], [embedding2])[0][0]
    return similarity

# Calculate Euclidean distance
def euclidean_distance_score(embedding1, embedding2):
    embedding1 = normalize(embedding1)
    embedding2 = normalize(embedding2)
    distance = np.linalg.norm(embedding1 - embedding2)
    return distance

# Determine match using both metrics
def is_match(embedding1, embedding2, cosine_threshold=0.65, euclidean_threshold=0.6):
    cosine_sim = cosine_similarity_score(embedding1, embedding2)
    euclidean_dist = euclidean_distance_score(embedding1, embedding2)

    # Log the scores for better debugging
    print(f"[DEBUG] Cosine Similarity: {cosine_sim:.4f}, Euclidean Distance: {euclidean_dist:.4f}")

    # Matching logic considering both similarity and distance
    if cosine_sim > cosine_threshold and euclidean_dist < euclidean_threshold:
        return True, cosine_sim, euclidean_dist
    return False, cosine_sim, euclidean_dist

# Load uploaded face embeddings and names
def load_uploaded_faces():
    global known_face_embeddings, known_face_names
    known_face_embeddings.clear()
    known_face_names.clear()

    for filename in os.listdir(uploaded_images_path):
        file_path = os.path.join(uploaded_images_path, filename)

        if filename.lower().endswith((".jpg", ".jpeg", ".png")):
            img = cv2.imread(file_path)
            faces = app.get(img)
            if len(faces) > 0:
                embedding = faces[0].embedding
                known_face_embeddings.append(embedding)
                known_face_names.append(filename.split(".")[0])
                print(f"[INFO] Loaded face from {file_path}")
                print(f"[DEBUG] Embedding (first 5 values): {embedding[:5]}")
            else:
                print(f"[WARNING] No face detected in {file_path}")

# Recognize a face from an uploaded image
def recognize_from_image(image_path):
    img = cv2.imread(image_path)
    faces = app.get(img)
    if not faces:
        print(f"[WARNING] No face detected in {image_path}")
        return {"match_status": "Not Match", "name": "Unknown", "similarity": 0.0}

    best_match_name = "Unknown"
    highest_similarity = 0
    lowest_distance = float('inf')
    match_status = "Not Match"

    for face in faces:
        embedding = face.embedding
        for known_name, known_embedding in zip(known_face_names, known_face_embeddings):
            match, cosine_sim, euclidean_dist = is_match(embedding, known_embedding)
            print(f"[DEBUG] Comparing with {known_name} - Cosine: {cosine_sim:.4f}, Euclidean: {euclidean_dist:.4f}")

            # Update match if both similarity and distance criteria are met
            if match and cosine_sim > highest_similarity:
                best_match_name = known_name
                highest_similarity = cosine_sim
                lowest_distance = euclidean_dist
                match_status = "Match"
                print(f"[INFO] Match found: {best_match_name} with Cosine: {cosine_sim:.4f}, Euclidean: {euclidean_dist:.4f}")

    return {
        "match_status": match_status,
        "name": best_match_name,
        "similarity": round(float(highest_similarity), 2),
        "distance": round(float(lowest_distance), 4)
    }
