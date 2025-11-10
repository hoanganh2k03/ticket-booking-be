import random
import string


def generate_otp(length=6):
    characters = string.digits  # OTP chỉ gồm chữ số
    otp = ''.join(random.choice(characters) for _ in range(length))
    return otp

