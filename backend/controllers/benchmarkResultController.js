import { db } from '../config/firebase.js';
import { COLLECTION_NAMES } from '../config/constants.js';
import { logger } from '../utils/logger.js';

/**
 * Receive benchmark result data from mobile app
 */
export const receiveBenchmarkResult = async (req, res) => {
  try {
    const data = req.body;

    console.log('\n=== Complete Data ===\n');
    console.log(JSON.stringify(data, null, 2));
    console.log('\n=====================================\n');

    // Check for duplicate based on combination of circuit, framework, language, and androidId
    const androidId = data.deviceInfo?.androidId;
    const circuit = data.circuit;
    const framework = data.framework;
    const language = data.language;
    const proofBackend = data.proofBackend;

    if (androidId && circuit && framework && language) {
      // Query Firestore to check if this exact combination already exists
      let query = db.collection(COLLECTION_NAMES.BENCHMARKS)
        .where('deviceInfo.androidId', '==', androidId)
        .where('circuit', '==', circuit)
        .where('framework', '==', framework)
        .where('language', '==', language);

      if (proofBackend) {
        query = query.where('proofBackend', '==', proofBackend);
      }

      const existingSnapshot = await query.limit(1).get();

      if (!existingSnapshot.empty) {
        logger.info(`Duplicate benchmark detected - Circuit: ${circuit}, Framework: ${framework}, Language: ${language}, Backend: ${proofBackend}, AndroidId: ${androidId}`);
        return res.status(200).json({
          success: false,
          message: 'Benchmark data already exists for this combination',
          duplicate: true,
          androidId: androidId,
          circuit: circuit,
          framework: framework,
          language: language,
          proofBackend: proofBackend
        });
      }
    }

    // Prepare data for Firestore, including custom inputs if they exist
    const firestoreData = {
      ...data,
      createdAt: new Date().toISOString(),
    };

    // If customInputs exists, process and add it
    if (data.customInputs) {
      // Assuming customInputs is an object like { "Proving time": "1024" }
      // We can add it directly to the document
      firestoreData.customInputs = data.customInputs;
    }

    // Add the benchmark data to Firestore
    const docRef = await db.collection(COLLECTION_NAMES.BENCHMARKS).add(firestoreData);

    logger.info(`Benchmark data saved successfully with ID: ${docRef.id}`);

    res.status(201).json({
      success: true,
      message: 'Benchmark result received and saved successfully',
      documentId: docRef.id,
      receivedAt: new Date().toISOString()
    });

  } catch (error) {
    logger.error('Error receiving benchmark result:', error);
    res.status(500).json({ error: error.message });
  }
};
