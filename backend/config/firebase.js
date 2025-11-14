import admin from 'firebase-admin';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load .env from backend root directory
dotenv.config({ path: join(__dirname, '../.env') });

// Parse the Firebase credentials from environment variable
if (!process.env.FIREBASE_ADMINSDK_CREDENTIALS) {
  throw new Error('FIREBASE_ADMINSDK_CREDENTIALS environment variable is not set. Please check your .env file.');
}

const serviceAccount = JSON.parse(process.env.FIREBASE_ADMINSDK_CREDENTIALS);

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

export { admin, db };
