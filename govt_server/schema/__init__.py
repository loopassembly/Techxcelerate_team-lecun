from pydantic import BaseModel, Field, ValidationError, EmailStr
from typing import Optional, List, Dict, Any


class TokenData(BaseModel):
    username: str = None


class SendMail(BaseModel):
    email: EmailStr = Field(..., example="example@example.com")