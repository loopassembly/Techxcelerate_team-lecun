from fastapi import FastAPI, HTTPException, Depends
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from datetime import datetime, timedelta
from typing import Optional, Dict
from pydantic import BaseModel
import jwt
from jwt import PyJWTError
import bcrypt
from database import Database
from schema import TokenData, SendMail
from template.mail import MAIL_TEMPLATE
from config.mail import MAIL_SERVER
import os
from dotenv import load_dotenv
from bson import ObjectId
import random
from fastapi.middleware.cors import CORSMiddleware


load_dotenv()
app = FastAPI()
db = Database()
mail = MAIL_SERVER()
mail_template = MAIL_TEMPLATE()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def read_root():
    try:
        return JSONResponse(
            content={"message": "Welcome to Konnect API 🚀", "status": "success"},
            status_code=200,
        )
    except Exception as e:
        return JSONResponse(
            content={"message": f"{str(e)}", "status": "error"}, status_code=500
        )


def verify_token(token: str, credentials_exception):
    try:
        payload = jwt.decode(
            token, os.getenv("JWT_SECRET"), algorithms=[os.getenv("JWT_ALGORITHM")]
        )
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
        return token_data
    except PyJWTError:
        raise credentials_exception


def get_current_user(
    token: str = Depends(OAuth2PasswordBearer(tokenUrl="api/auth/login")),
):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    token_data = verify_token(token, credentials_exception)
    if token_data is None:
        raise credentials_exception
    return token_data


def generate_access_token(data: Dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update(
        {
            "exp": expire,
            "sub": data["sub"],
            "iss": "kz",
            "iat": datetime.utcnow(),
            "nbf": datetime.utcnow(),
        }
    )
    encoded_jwt = jwt.encode(
        to_encode,
        os.getenv("JWT_SECRET"),
        algorithm=os.getenv("JWT_ALGORITHM"),
        headers={"typ": "JWT", "alg": os.getenv("JWT_ALGORITHM")},
    )
    return encoded_jwt



# Example usage for database connection
# Database connection is defined in api/database/main.py
# Database connection is tested by inserting a test document in the collection
@app.get("/api/test/db/connect")
async def test_db_connection():
    try:
        created_collection = db.get_collection("test")
        created_collection.insert_one({"test": "test"})  # Inserting a test document
        return JSONResponse(
            content={"message": "Database connection successful", "status": "success"},
            status_code=200,
        )
    except Exception as e:
        return JSONResponse(
            content={"message": f"{str(e)}", "status": "error"}, status_code=500
        )

# Example usage for sending mail
# Mail template is defined in api/template/mail/main.py
# Send mail function is defined in api/config/mail/main.py
@app.post("/api/test/mail")
async def test_mail(email: SendMail):
    try:
        mail_content = mail_template.send_otp(
            mail_body="This is a test mail for OTP Verification sent by Konnect", otp_code=random.randint(1000, 9999)
        )
        try:
            await mail.send_mail(
                mail_recepient=email.email,
                mail_subject="This is a test mail sent by Konnect",
                mail_body=mail_content
            )
            return JSONResponse(
                content={"message": "Mail sent successfully", "status": "success"},
                status_code=200,
            )
        except Exception as e:
            return JSONResponse(
                content={"message": f"{str(e)}", "status": "error"}, status_code=500
            )
    except Exception as e:
        return JSONResponse(
            content={"message": f"{str(e)}", "status": "error"}, status_code=500
        )
        
