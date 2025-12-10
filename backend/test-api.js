// ✅ Deimos Backend API Test Script
// Uses HTTPS and fetch instead of http for Render deployment

import fetch from 'node-fetch';

const API_BASE = 'https://deimos-fork.onrender.com';

// Test data matching the Flutter app structure
const testBenchmarkData = {
  "circuit": "Poseidon",
  "framework": "MoPro",
  "language": "circom",
  "provingTimeMiliSeconds": 2463,
  "verificationTimeMiliSeconds": 222,
  "deviceInfo": {
    "platform": "Android",
    "device": "sdk_gphone64_x86_64",
    "manufacturer": "Google",
    "androidVersion": "14",
    "androidId": "TEST_ANDROID_ID_123",
    "memory": {
      "totalPhysicalMemory": 2069602304,
      "memoryUsedBeforeProof": 1860489216,
      "peakMemoryUsage": 1923002368,
      "memoryConsumedByProof": 62513152,
      "peakMemoryLoadInPercentage": 92.91651658308166,
      "memoryConsumedInPercentage": 3.0205393509264282
    },
    "battery": {
      "batteryBeforeProof": 100,
      "batteryAfterProof": 100,
      "batteryConsumed": 0
    }
  },
  "proofSize": 1073,
  "timestamp": "2025-11-11T11:23:27.366651"
};

async function makeRequest(method, path, data = null) {
  const url = `${API_BASE}${path}`;
  const options = {
    method,
    headers: { 'Content-Type': 'application/json' }
  };
  if (data) options.body = JSON.stringify(data);

  const res = await fetch(url, options);
  const text = await res.text();
  try {
    return { statusCode: res.status, data: JSON.parse(text) };
  } catch {
    return { statusCode: res.status, data: text };
  }
}

async function runTests() {
  console.log('🧪 Testing Deimos Backend API\n');

  try {
    // Test 1: Health Check
    console.log('1️⃣  Testing health endpoint...');
    const health = await makeRequest('GET', '/api/health');
    console.log(`   Status: ${health.statusCode}`, health.data);
    console.log(health.statusCode === 200 ? '   ✅ PASSED\n' : '   ❌ FAILED\n');

    // Test 2: Filters
    console.log('2️⃣  Testing filters endpoint...');
    const filters = await makeRequest('GET', '/api/filters');
    console.log(`   Status: ${filters.statusCode}`, filters.data);
    console.log(filters.statusCode === 200 ? '   ✅ PASSED\n' : '   ❌ FAILED\n');

    // Test 3: Submit Benchmark
    console.log('3️⃣  Testing benchmark submission...');
    const submit = await makeRequest('POST', '/api/benchmark-result', testBenchmarkData);
    console.log(`   Status: ${submit.statusCode}`, submit.data);
    console.log(submit.statusCode === 201 ? '   ✅ PASSED\n' : '   ❌ FAILED\n');

    // Test 4: Duplicate Detection
    console.log('4️⃣  Testing duplicate detection...');
    const duplicate = await makeRequest('POST', '/api/benchmark-result', testBenchmarkData);
    console.log(`   Status: ${duplicate.statusCode}`, duplicate.data);
    console.log(duplicate.data?.duplicate ? '   ✅ PASSED (Duplicate detected)\n' : '   ❌ FAILED\n');

    // Test 5: Benchmarks List
    console.log('5️⃣  Testing benchmarks endpoint...');
    const benchmarks = await makeRequest('GET', '/api/benchmarks?page=1&limit=10');
    console.log(`   Status: ${benchmarks.statusCode}`);
    console.log(`   Total Count: ${benchmarks.data?.pagination?.totalCount || 0}`);
    console.log(`   Data Items: ${benchmarks.data?.data?.length || 0}`);
    console.log(benchmarks.statusCode === 200 ? '   ✅ PASSED\n' : '   ❌ FAILED\n');

    // Test 6: Filtered Benchmarks
    console.log('6️⃣  Testing filtered benchmarks...');
    const filtered = await makeRequest('GET', '/api/benchmarks?circuit=Poseidon&platform=Android');
    console.log(`   Status: ${filtered.statusCode}`);
    console.log(`   Filtered Count: ${filtered.data?.pagination?.totalCount || 0}`);
    console.log(filtered.statusCode === 200 ? '   ✅ PASSED\n' : '   ❌ FAILED\n');

    console.log('✨ All tests completed!');

  } catch (err) {
    console.error('❌ Test failed with error:', err.message);
    console.error('   Ensure https://deimos-fork.onrender.com is reachable.');
  }
}

runTests();
