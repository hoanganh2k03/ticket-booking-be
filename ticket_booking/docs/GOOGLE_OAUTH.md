# Google Sign-In (OAuth2) Setup

This project supports Google Sign-In for customer accounts via a backend endpoint and frontend Google Identity Services.

Steps to enable:

1. Create an OAuth 2.0 Client ID in Google Cloud Console (type: Web application).
   - Add authorized JavaScript origins (e.g., `http://localhost:5500`) and authorized redirect URIs if needed.
   - Copy the **Client ID**.

2. Backend configuration
   - Open `ticket_booking/settings.py` and set `GOOGLE_CLIENT_ID = '<YOUR_GOOGLE_CLIENT_ID>'`.

3. Frontend configuration
   - Open `js/utils/settings.js` and set `GOOGLE_CLIENT_ID` to the same value.

4. Restart Django and reload the frontend page. The Google Sign-In button should appear on the customer login page.

Notes:
- The backend verifies the `id_token` using Google's tokeninfo endpoint and creates a verified customer account if one does not exist.
- For production, ensure `GOOGLE_CLIENT_ID` is set from secure environment variables and that `ALLOWED_HOSTS`/origins are configured correctly.
