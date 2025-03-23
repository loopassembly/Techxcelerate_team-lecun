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
from schema import TokenData, RequestBirthCertificateData, RequestAadharData, RequestPanData, RequestDrivingLicenseData, SendDocData
from config.phone import OTP
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
otp_server = OTP()

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
            content={"message": "Welcome to Govt API 🚀", "status": "success"},
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





        
@app.post("/api/request/aadhaar")
async def request_aadhaar(data: RequestAadharData):
    try:
        otp_collection = db.get_collection("otp-request")
        get_collection = db.get_collection("data")
        
        # Find Aadhaar Data
        get_aadhaar_data = get_collection.find_one({"aadhar.uid": str(data.aadhar_number)})
        
        if not get_aadhaar_data:
            return JSONResponse(
                content={"message": "Aadhaar Number not found", "status": "error"},
                status_code=404,
            )

        phone_number = get_aadhaar_data.get("aadhar", {}).get("mobile_number")
        
        if not phone_number:
            return JSONResponse(
                content={"message": "Mobile number not linked to Aadhaar", "status": "error"},
                status_code=400,
            )
        
        # Generate OTP
        otp = random.randint(100000, 999999)
        
        
        # Fix: Convert OTP to string before hashing
        hashed_otp = bcrypt.hashpw(str(otp).encode("utf-8"), bcrypt.gensalt())
        

        # Send OTP via external service
        res = await otp_server.send_otp(phone_number=phone_number, otp=otp, doc_type="Aadhaar")

        if res and res["return"] is True and "successfully" in res["message"][0]:
            request_id = res["request_id"]
            
            otp_data = {
                "request_id": request_id,
                "otp": hashed_otp,  # Fix: Convert hashed bytes to string
                "doc_type": "Aadhaar",
                "doc_number": data.aadhar_number,
                "created_at": datetime.now(),
                "valid_till": datetime.now() + timedelta(minutes=10)
            }
            otp_collection.insert_one(otp_data)

            return JSONResponse(
                content={"message": "OTP Sent Successfully",
                         "data": {"request_id": request_id, "type": "Aadhaar", "expires_in": 10},
                         "status": "success"},
                status_code=200,
            )

        return JSONResponse(
            content={"message": "OTP Sending Failed", "status": "error"}, status_code=500
        )
    
    except Exception as e:
        return JSONResponse(
            content={"message": f"Error: {str(e)}", "status": "error"}, status_code=500
        )
        

@app.post("/api/request/pan")
async def request_pan(data: RequestPanData):
    try:
        otp_collection = db.get_collection("otp-request")
        get_collection = db.get_collection("data")
        
        # Find Aadhaar Data
        get_pan_data = get_collection.find_one({"pan.number": str(data.pan_number)})
        
        if not get_pan_data:
            return JSONResponse(
                content={"message": "PAN Number not found", "status": "error"},
                status_code=404,
            )

        phone_number = get_pan_data.get("pan", {}).get("mobile_number")
        
        if not phone_number:
            return JSONResponse(
                content={"message": "Mobile number not linked to Pan", "status": "error"},
                status_code=400,
            )
        
        # Generate OTP
        otp = random.randint(100000, 999999)
        
        
        # Fix: Convert OTP to string before hashing
        hashed_otp = bcrypt.hashpw(str(otp).encode("utf-8"), bcrypt.gensalt())
        

        # Send OTP via external service
        res = await otp_server.send_otp(phone_number=phone_number, otp=otp, doc_type="PAN")

        if res and res["return"] is True and "successfully" in res["message"][0]:
            request_id = res["request_id"]
            
            otp_data = {
                "request_id": request_id,
                "otp": hashed_otp,  # Fix: Convert hashed bytes to string
                "doc_type": "PAN",
                "doc_number": data.pan_number,
                "created_at": datetime.now(),
                "valid_till": datetime.now() + timedelta(minutes=10)
            }
            otp_collection.insert_one(otp_data)
            return JSONResponse(
                content={"message": "OTP Sent Successfully",
                         "data": {"request_id": request_id, "type": "PAN", "expires_in": 10},
                         "status": "success"},
                status_code=200,
            )

        return JSONResponse(
            content={"message": "OTP Sending Failed", "status": "error"}, status_code=500
        )
    
    except Exception as e:
        return JSONResponse(
            content={"message": f"Error: {str(e)}", "status": "error"}, status_code=500
        )
        
        
@app.post("/api/request/dl")
async def request_dl(data: RequestDrivingLicenseData):
    try:
        otp_collection = db.get_collection("otp-request")
        get_collection = db.get_collection("data")
        
        # Find Aadhaar Data
        get_dl_data = get_collection.find_one({"driving_license.number": str(data.dl_number)})
        
        if not get_dl_data:
            return JSONResponse(
                content={"message": "Driving License Number not found", "status": "error"},
                status_code=404,
            )

        phone_number = get_dl_data.get("driving_license", {}).get("mobile_number")
        
        if not phone_number:
            return JSONResponse(
                content={"message": "Mobile number not linked to Driving License", "status": "error"},
                status_code=400,
            )
        
        # Generate OTP
        otp = random.randint(100000, 999999)
        
        
        # Fix: Convert OTP to string before hashing
        hashed_otp = bcrypt.hashpw(str(otp).encode("utf-8"), bcrypt.gensalt())
        

        # Send OTP via external service
        res = await otp_server.send_otp(phone_number=phone_number, otp=otp, doc_type="DL")

        if res and res["return"] is True and "successfully" in res["message"][0]:
            request_id = res["request_id"]
            
            otp_data = {
                "request_id": request_id,
                "otp": hashed_otp,  # Fix: Convert hashed bytes to string
                "doc_type": "DL",
                "doc_number": data.dl_number,
                "created_at": datetime.now(),
                "valid_till": datetime.now() + timedelta(minutes=10)
            }
            otp_collection.insert_one(otp_data)
            return JSONResponse(
                content={"message": "OTP Sent Successfully",
                         "data": {"request_id": request_id, "type": "DL", "expires_in": 10},
                         "status": "success"},
                status_code=200,
            )

        return JSONResponse(
            content={"message": "OTP Sending Failed", "status": "error"}, status_code=500
        )
    
    except Exception as e:
        return JSONResponse(
            content={"message": f"Error: {str(e)}", "status": "error"}, status_code=500
        )
        
            

@app.post("/api/send/doc")
async def send_doc(data: SendDocData):
    try:
        otp_collection = db.get_collection("otp-request")
        get_otp_data = otp_collection.find_one({"request_id": data.requestId})
        if not get_otp_data:
            return JSONResponse(
                content={"message": "Invalid Request ID", "status": "error"},
                status_code=404,
            )
        if datetime.now() > get_otp_data["valid_till"]:
            return JSONResponse(
                content={"message": "OTP Expired", "status": "error"},
                status_code=400,
            )
        if bcrypt.checkpw(data.otp.encode("utf-8"), get_otp_data["otp"]):
            get_collection = db.get_collection("data")
            doc_type = get_otp_data["doc_type"]
            if doc_type == "Aadhaar" :
                get_aadhaar_data = get_collection.find_one({"aadhar.uid": get_otp_data["doc_number"]})
                otp_collection.update_one({"request_id": data.requestId}, {"$set": {"valid_till": datetime.now()}})
                return JSONResponse(
                    content={"message": "Document Sent Successfully",
                             "data": get_aadhaar_data["aadhar"],
                             "status": "success"},
                    status_code=200,
                )
            elif doc_type == "PAN" :
                get_pan_data = get_collection.find_one({"pan.number": get_otp_data["doc_number"]})
                otp_collection.update_one({"request_id": data.requestId}, {"$set": {"valid_till": datetime.now()}})
                return JSONResponse(
                    content={"message": "Document Sent Successfully",
                             "data": get_pan_data["pan"],
                             "status": "success"},
                    status_code=200,
                )
            elif doc_type == "DL" :
                get_dl_data = get_collection.find_one({"driving_license.number": get_otp_data["doc_number"]})
                otp_collection.update_one({"request_id": data.requestId}, {"$set": {"valid_till": datetime.now()}})
                return JSONResponse(
                    content={"message": "Document Sent Successfully",
                             "data": get_dl_data["driving_license"],
                             "status": "success"},
                    status_code=200,
                )
            else :
                return JSONResponse(
                    content={"message": "Invalid Document Type", "status": "error"},
                    status_code=400,
                )    
            
        return JSONResponse(
            content={"message": "Invalid OTP", "status": "error"}, status_code=400
        )
    except Exception as e:
        return JSONResponse(
            content={"message": f"{str(e)}", "status": "error"}, status_code=500
        )