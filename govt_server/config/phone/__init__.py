import httpx

class OTP:
    otp_api_auth_key = "7EkwaqG3tXCYfrRFJpDVyBTUAui8v1Pm9d5NKl0LczhQOMnWbjkh9PyGazwr0VSe7Z8jq3xLJcufNMbO"
    
    def __init__(self):
        self.url = "https://www.fast2sms.com/dev/bulkV2"
        
    async def send_otp(self, phone_number, otp, doc_type):
        querystring = {
            "authorization": self.otp_api_auth_key,
            "message": f"{otp} is your OTP for {doc_type} access.",
            "language": "english",
            "route": "q",
            "numbers": phone_number,
        }
        headers = {
            "cache-control": "no-cache",
        }

        async with httpx.AsyncClient() as client:
            response = await client.get(self.url, headers=headers, params=querystring)
        
        return response.json()  # Ensure response content is returned properly
