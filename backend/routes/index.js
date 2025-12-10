import express from 'express';
import benchmarkRoutes from './benchmarkRoutes.js';
import { receiveBenchmarkResult } from '../controllers/benchmarkResultController.js';

const router = express.Router();

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Deimos Backend API is running' });
});

// Receive benchmark result from mobile app
router.post('/benchmark-result', receiveBenchmarkResult);

// Mount benchmark routes
router.use('/', benchmarkRoutes);

export default router;
