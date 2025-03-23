from pydantic import BaseModel, Field, ValidationError, EmailStr
from typing import Optional, List, Dict, Any


class TokenData(BaseModel):
    username: str = None


class RequestBirthCertificateData(BaseModel):
    applicationNumber: str = Field(...)
    name: str = Field(..., min_length=3, max_length=50)
    dob: str = Field(..., min_length=10, max_length=10)
    

class RequestAadharData(BaseModel):
    aadhaar_number: str = Field(..., min_length=12, max_length=12)

class SendDocData(BaseModel):
    requestId: str = Field(...)
    otp: str = Field(..., min_length=6, max_length=6)

class RequestPanData(BaseModel):
    pan_number: str = Field(..., min_length=10, max_length=10)
    
class RequestDrivingLicenseData(BaseModel):
    dl_number: str = Field(..., min_length=15, max_length=15)
    
class URLRequest(BaseModel):
    id: str  # Unique identifier
    name: str  # User or resource name

    
