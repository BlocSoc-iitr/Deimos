// Script to populate Firestore with dummy benchmark data
import { db } from './config/firebase.js';
import { COLLECTION_NAMES } from './config/constants.js';
import { logger } from './utils/logger.js';

const circuits = ['Poseidon', 'SHA256', 'Keccak256', 'Blake2s256', 'MiMC256', 'Pedersen'];
const frameworks = ['MoPro']; // Only one framework
const languages = ['circom', 'noir', 'halo2']; // Three languages
const platforms = ['Android', 'iOS'];

const androidDevices = [
  { device: 'Pixel 7 Pro', manufacturer: 'Google', version: '14' },
  { device: 'Galaxy S23 Ultra', manufacturer: 'Samsung', version: '14' },
  { device: 'OnePlus 11', manufacturer: 'OnePlus', version: '13' },
  { device: 'Xiaomi 13 Pro', manufacturer: 'Xiaomi', version: '13' },
  { device: 'sdk_gphone64_x86_64', manufacturer: 'Google', version: '14' },
  { device: 'Pixel 6', manufacturer: 'Google', version: '13' },
  { device: 'Galaxy A54', manufacturer: 'Samsung', version: '13' },
  { device: 'Redmi Note 12 Pro', manufacturer: 'Xiaomi', version: '12' },
];

const iosDevices = [
  { device: 'iPhone 15 Pro', systemName: 'iOS', systemVersion: '17.1' },
  { device: 'iPhone 14', systemName: 'iOS', systemVersion: '17.0' },
  { device: 'iPhone 13 Pro Max', systemName: 'iOS', systemVersion: '16.6' },
  { device: 'iPad Pro 12.9', systemName: 'iPadOS', systemVersion: '17.1' },
];

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomFloat(min, max, decimals = 2) {
  return parseFloat((Math.random() * (max - min) + min).toFixed(decimals));
}

function randomElement(array) {
  return array[Math.floor(Math.random() * array.length)];
}

function generateAndroidId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let id = '';
  for (let i = 0; i < 16; i++) {
    id += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return `UE1A.${randomInt(200000, 999999)}.${randomInt(100, 999)}.${id}`;
}

function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

function generateTimestamp(daysAgo) {
  const date = new Date();
  date.setDate(date.getDate() - daysAgo);
  date.setHours(randomInt(0, 23), randomInt(0, 59), randomInt(0, 59));
  return date.toISOString();
}

function generateMemoryInfo(platform) {
  const totalMemory = platform === 'Android' 
    ? randomInt(2, 16) * 1024 * 1024 * 1024  // 2-16 GB
    : randomInt(4, 8) * 1024 * 1024 * 1024;   // 4-8 GB for iOS
  
  const memoryUsedBefore = Math.floor(totalMemory * randomFloat(0.6, 0.85));
  const memoryConsumed = Math.floor(totalMemory * randomFloat(0.02, 0.08));
  const peakMemoryUsage = memoryUsedBefore + memoryConsumed;
  const peakMemoryLoadPercentage = (peakMemoryUsage / totalMemory) * 100;
  const memoryConsumedPercentage = (memoryConsumed / totalMemory) * 100;

  return {
    totalPhysicalMemory: totalMemory,
    memoryUsedBeforeProof: memoryUsedBefore,
    peakMemoryUsage: peakMemoryUsage,
    memoryConsumedByProof: memoryConsumed,
    peakMemoryLoadInPercentage: parseFloat(peakMemoryLoadPercentage.toFixed(2)),
    memoryConsumedInPercentage: parseFloat(memoryConsumedPercentage.toFixed(2))
  };
}

function generateBatteryInfo() {
  const batteryBefore = randomInt(20, 100);
  const batteryConsumed = randomInt(0, 3);
  return {
    batteryBeforeProof: batteryBefore,
    batteryAfterProof: batteryBefore - batteryConsumed,
    batteryConsumed: batteryConsumed
  };
}

function generateBenchmarkData() {
  const circuit = randomElement(circuits);
  const framework = 'MoPro'; // Always MoPro
  const language = randomElement(languages);
  const platform = randomElement(platforms);
  
  // Proving time varies by circuit and language (realistic ranges)
  // Circom: 1-5 seconds, Noir: 2-8 seconds, Halo2: 3-10 seconds
  let provingTimeRange;
  if (language === 'circom') {
    provingTimeRange = [1000, 5000];
  } else if (language === 'noir') {
    provingTimeRange = [2000, 8000];
  } else { // halo2
    provingTimeRange = [3000, 10000];
  }
  const provingTime = randomInt(provingTimeRange[0], provingTimeRange[1]);
  
  // Verification is typically much faster (50-500ms)
  const verificationTime = randomInt(50, 500);
  
  // Proof size varies by circuit (realistic range: 800-2000 bytes)
  const proofSize = randomInt(800, 2000);
  
  let deviceInfo;
  
  if (platform === 'Android') {
    const device = randomElement(androidDevices);
    deviceInfo = {
      platform: 'Android',
      device: device.device,
      manufacturer: device.manufacturer,
      androidVersion: device.version,
      androidId: generateAndroidId(),
      memory: generateMemoryInfo('Android'),
      battery: generateBatteryInfo()
    };
  } else {
    const device = randomElement(iosDevices);
    deviceInfo = {
      platform: 'iOS',
      device: device.device,
      systemName: device.systemName,
      systemVersion: device.systemVersion,
      name: device.device,
      identifierForVendor: generateUUID(),
      isPhysicalDevice: true,
      memory: generateMemoryInfo('iOS'),
      battery: generateBatteryInfo()
    };
  }
  
  return {
    circuit,
    framework,
    language,
    provingTimeMiliSeconds: provingTime,
    verificationTimeMiliSeconds: verificationTime,
    deviceInfo,
    proofSize,
    timestamp: generateTimestamp(randomInt(0, 30)), // Random date within last 30 days
    createdAt: new Date().toISOString()
  };
}

async function populateDatabase(count = 50) {
  console.log(`🚀 Starting to populate database with ${count} dummy benchmark entries...\n`);
  
  try {
    const batch = db.batch();
    let batchCount = 0;
    let totalAdded = 0;
    
    for (let i = 0; i < count; i++) {
      const data = generateBenchmarkData();
      const docRef = db.collection(COLLECTION_NAMES.BENCHMARKS).doc();
      batch.set(docRef, data);
      batchCount++;
      
      // Firestore batch limit is 500, commit in batches of 400 to be safe
      if (batchCount === 400 || i === count - 1) {
        await batch.commit();
        totalAdded += batchCount;
        console.log(`✅ Added ${batchCount} entries (Total: ${totalAdded}/${count})`);
        batchCount = 0;
      }
    }
    
    console.log(`\n🎉 Successfully populated database with ${totalAdded} benchmark entries!`);
    console.log('\n📊 Summary:');
    console.log(`   - Circuits: ${circuits.join(', ')}`);
    console.log(`   - Framework: ${frameworks[0]} (only framework)`);
    console.log(`   - Languages: ${languages.join(', ')}`);
    console.log(`   - Platforms: ${platforms.join(', ')}`);
    console.log(`   - Android Devices: ${androidDevices.length} different models`);
    console.log(`   - iOS Devices: ${iosDevices.length} different models`);
    
  } catch (error) {
    logger.error('Error populating database:', error);
    console.error('❌ Failed to populate database:', error.message);
  }
}

// Get count from command line argument or default to 50
const count = parseInt(process.argv[2]) || 50;

if (count < 1 || count > 1000) {
  console.error('❌ Please provide a count between 1 and 1000');
  process.exit(1);
}

populateDatabase(count).then(() => {
  console.log('\n✨ Done!');
  process.exit(0);
}).catch(error => {
  console.error('❌ Error:', error);
  process.exit(1);
});
