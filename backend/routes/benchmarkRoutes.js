import express from 'express';
import { getBenchmarks, getFilters } from '../controllers/benchmarkController.js';

const router = express.Router();

// GET /api/benchmarks - Get filtered and paginated benchmark data
router.get('/benchmarks', getBenchmarks);

// GET /api/filters - Get unique filter values
router.get('/filters', getFilters);

export default router;
