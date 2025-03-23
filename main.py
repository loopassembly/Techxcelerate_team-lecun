import os
import cv2
import shutil
from fastapi import FastAPI, File, UploadFile
import numpy as np
import insightface
from insightface.app import FaceAnalysis

# Initialize the FastAPI app
app = FastAPI()

# Create the uploaded_images directory if it doesn't exist
uploaded_images_dir = "uploaded_images"
if not os.path.exists(uploaded_images_dir):
    os.makedirs(uploaded_images_dir)

# Initialize the InsightFace model
model = FaceAnalysis(name="buffalo_l", providers=["CPUExecutionProvider"])
model.prepare(ctx_id=0)

@app.post("/upload_verify")
async def upload_and_verify(file: UploadFile = File(...)):
    file_path = os.path.join(uploaded_images_dir, file.filename)

    # Save the uploaded file
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Check if there are existing images in the directory
    existing_images = [img for img in os.listdir(uploaded_images_dir) if img != file.filename]
    if existing_images:
        # Compare with the first existing image (you can modify to compare with all)
        existing_image_path = os.path.join(uploaded_images_dir, existing_images[0])
        
        # Load images
        img1 = model.get(cv2.imread(existing_image_path))
        img2 = model.get(cv2.imread(file_path))

        # Check if faces are detected in both images
        if len(img1) == 0 or len(img2) == 0:
            return {"message": "No face detected in one or both images"}

        # Extract embeddings
        embedding1 = img1[0].embedding
        embedding2 = img2[0].embedding

        # Calculate similarity
        similarity = np.dot(embedding1, embedding2) / (np.linalg.norm(embedding1) * np.linalg.norm(embedding2))
        distance = np.linalg.norm(embedding1 - embedding2)

        # Set a similarity threshold (adjust as needed)
        threshold = 0.5
        match_status = "Match" if similarity > threshold else "Not Match"

        # Clean up the previous uploaded image and save the new one
        os.remove(existing_image_path)
        return {
            "match_status": match_status,
            "similarity": float(similarity),
            "distance": float(distance)
        }

    # If no previous images, save the current one as a reference image
    return {"message": "Image uploaded successfully as reference"}
