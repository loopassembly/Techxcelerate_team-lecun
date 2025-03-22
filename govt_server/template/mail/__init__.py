class MAIL_TEMPLATE:

    def send_otp(self, mail_body, otp_code):
        return f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <title>OTP Verification</title>
    </head>
    <body>
        <div>
            <h3>OTP Verification</h3>
            <p>{mail_body}</p>
            <p style="font-weight: 500;">Your OTP is: {otp_code}</p>
        </div>
    </body>
    </html>
    """
