from fastapi import FastAPI, UploadFile, File
import os
from face_verification import load_uploaded_faces, recognize_from_image

# Create FastAPI instance
app_api = FastAPI()

# Directory to save uploaded images
uploaded_images_path = "C:/Users/AMOGH/OneDrive/Desktop/Photo Verification 2/Uploaded_Images"
os.makedirs(uploaded_images_path, exist_ok=True)

@app_api.get("/")
async def root():
    return {"message": "Face Recognition API is running"}

@app_api.post("/upload_verify")
async def upload_and_verify(file: UploadFile = File(...)):
    try:
        # Save the uploaded file
        file_path = os.path.join(uploaded_images_path, file.filename)
        with open(file_path, "wb") as f:
            f.write(await file.read())

        # Load uploaded faces to update the list
        load_uploaded_faces()

        # Perform face recognition on the uploaded file
        result = recognize_from_image(file_path)

        # Delete the uploaded image after processing
        os.remove(file_path)

        return result
    except Exception as e:
        return {"error": str(e)}
