import { db } from '../config/firebase.js';
import { COLLECTION_NAMES } from '../config/constants.js';
import { logger } from '../utils/logger.js';

/**
 * Get filtered and paginated benchmark data
 */
export const getBenchmarks = async (req, res) => {
  try {
    const {
      circuit = 'all',
      framework = 'all',
      language = 'all',
      platform = 'all',
      page = '1',
      limit = '10'
    } = req.query;

    // Parse pagination parameters
    const pageNum = parseInt(page);
    const limitNum = parseInt(limit);

    if (isNaN(pageNum) || pageNum < 1) {
      return res.status(400).json({ error: 'Invalid page number' });
    }

    if (isNaN(limitNum) || limitNum < 1) {
      return res.status(400).json({ error: 'Invalid limit' });
    }

    // Build Firestore query
    let query = db.collection(COLLECTION_NAMES.BENCHMARKS);

    // Apply filters
    if (circuit !== 'all') {
      query = query.where('circuit', '==', circuit);
    }
    if (framework !== 'all') {
      query = query.where('framework', '==', framework);
    }
    if (language !== 'all') {
      query = query.where('language', '==', language);
    }
    if (platform !== 'all') {
      query = query.where('deviceInfo.platform', '==', platform);
    }

    // Get all filtered data
    const snapshot = await query.get();

    // Convert to array and sort by timestamp (latest to oldest)
    const allData = [];
    snapshot.forEach(doc => {
      allData.push({
        id: doc.id,
        ...doc.data()
      });
    });

    // Sort by timestamp in descending order (latest first)
    allData.sort((a, b) => {
      const timeA = new Date(a.timestamp || a.createdAt || 0).getTime();
      const timeB = new Date(b.timestamp || b.createdAt || 0).getTime();
      return timeB - timeA; // Descending order
    });
    
    // Get total count
    const totalCount = allData.length;
    
    // Calculate pagination
    const startIndex = (pageNum - 1) * limitNum;
    const endIndex = startIndex + limitNum;
    
    // Get paginated slice
    const data = allData.slice(startIndex, endIndex);

    // Calculate total pages
    const totalPages = Math.ceil(totalCount / limitNum);

    res.json({
      data,
      pagination: {
        currentPage: pageNum,
        totalPages,
        totalCount,
        limit: limitNum,
        hasNextPage: pageNum < totalPages,
        hasPrevPage: pageNum > 1
      }
    });
  } catch (error) {
    logger.error('Error fetching benchmarks:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Get unique filter values
 */
export const getFilters = async (req, res) => {
  try {
    const snapshot = await db.collection(COLLECTION_NAMES.BENCHMARKS).get();
    
    const circuits = new Set();
    const frameworks = new Set();
    const languages = new Set();
    const platforms = new Set();

    snapshot.forEach(doc => {
      const data = doc.data();
      if (data.circuit) circuits.add(data.circuit);
      if (data.framework) frameworks.add(data.framework);
      if (data.language) languages.add(data.language);
      if (data.deviceInfo?.platform) platforms.add(data.deviceInfo.platform);
    });

    res.json({
      circuits: ['all', ...Array.from(circuits).sort()],
      frameworks: ['all', ...Array.from(frameworks).sort()],
      languages: ['all', ...Array.from(languages).sort()],
      platforms: ['all', ...Array.from(platforms).sort()]
    });
  } catch (error) {
    logger.error('Error fetching filters:', error);
    res.status(500).json({ error: error.message });
  }
};
