# Facebook OAuth Integration

- Add `FACEBOOK_APP_ID` and `FACEBOOK_APP_SECRET` to `ticket_booking/settings.py`.
- On frontend, set `FACEBOOK_APP_ID` in `js/utils/settings.js`.
- Use the `auth/customer/facebook/` endpoint which accepts `access_token` from Facebook SDK and returns JWT tokens.
- How the flow works:
  1. Frontend uses the Facebook JS SDK to get an access token.
  2. Frontend POSTs `{ access_token }` to `/api/accounts/auth/customer/facebook/`.
  3. The backend verifies token via `https://graph.facebook.com/me?access_token=...&fields=id,name,email`.
  4. Backend creates or reuses Customer & CustomerAccount, sets `faceid`, marks account as verified, creates tokens, and returns them.

Notes:
- Ensure the Facebook app has the `email` permission if you want to rely on email matching.
- If the database already has multiple users with the same Facebook ID (should not happen), migration may fail with a unique constraint violation. In that case, manually check and dedupe DB records before applying migration.
