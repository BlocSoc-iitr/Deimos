import pg from 'pg';
import { config } from './constants.js';
import { logger } from '../utils/logger.js';

const { Pool } = pg;

const pool = new Pool({
  host: config.db.host,
  port: config.db.port,
  database: config.db.database,
  user: config.db.user,
  password: config.db.password,
});

pool.on('error', (err) => {
  logger.error('Unexpected PostgreSQL pool error:', err);
});

/**
 * Query helper with logging
 */
export const query = async (text, params) => {
  const start = Date.now();
  const result = await pool.query(text, params);
  const duration = Date.now() - start;
  logger.debug(`Query executed in ${duration}ms: ${text.substring(0, 80)}...`);
  return result;
};

/**
 * Get a client from the pool (for transactions)
 */
export const getClient = () => pool.connect();

export { pool };
