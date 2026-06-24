import express from 'express';
import benchmarkRoutes from './benchmarkRoutes.js';
import { receiveBenchmarkResult, receiveBenchmarkResults } from '../controllers/benchmarkResultController.js';

const router = express.Router();

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Deimos Backend API is running' });
});

// Receive a single benchmark result from mobile app
router.post('/benchmark-result', receiveBenchmarkResult);

// Receive many benchmark results in one request (batch flow)
router.post('/benchmark-results', receiveBenchmarkResults);

// Mount benchmark routes
router.use('/', benchmarkRoutes);

export default router;
