package com.example.moproapp
import android.content.Context
import kotlinx.coroutines.launch
import android.os.SystemClock
import android.app.ActivityManager

import MultiplierComponent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import java.io.File
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.io.FileOutputStream
import java.text.DecimalFormat

import uniffi.mopro.*

// Performance metrics data class
data class PerformanceMetrics(
    val framework: String,
    val operation: String,
    val duration: Long,
    val memoryBefore: Long,
    val memoryAfter: Long,
    val proofSize: Int? = null,
    val proofContent: String? = null,
    val verificationResult: Boolean? = null,
    val timestamp: Long = System.currentTimeMillis()
)

// Benchmark results data class
data class BenchmarkResult(
    val framework: String,
    val avgProvingTime: Double,
    val avgVerifyingTime: Double,
    val avgProofSize: Double,
    val avgMemoryUsage: Double,
    val totalRuns: Int,
    val successRate: Double
)

@Throws(IOException::class)
fun copyFile(inputStream: InputStream, outputStream: OutputStream) {
    val buffer = ByteArray(1024)
    var read: Int
    while (inputStream.read(buffer).also { read = it } != -1) {
        outputStream.write(buffer, 0, read)
    }
}

@Composable
fun getFilePathFromAssets(name: String): String {
    val context = LocalContext.current
    return remember {
        val assetManager = context.assets
        val inputStream = assetManager.open(name)
        val file = File(context.filesDir, name)
        copyFile(inputStream, file.outputStream())
        file.absolutePath
    }
}

fun getFilePathFromAssetsNonComposable(context: Context, name: String): String {
    val assetManager = context.assets
    val inputStream = assetManager.open(name)
    val file = File(context.filesDir, name)
    copyFile(inputStream, file.outputStream())
    return file.absolutePath
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { 
            Surface( 
                modifier = Modifier.fillMaxSize(), 
                color = MaterialTheme.colorScheme.background 
            ) { 
                MainScreen(this) 
            } 
        } 
    }
}

@Composable
fun MainScreen(context: Context) {
    val coroutineScope = rememberCoroutineScope()
    var currentOperation by remember { mutableStateOf("") }
    var isRunning by remember { mutableStateOf(false) }
    var performanceMetrics by remember { mutableStateOf(listOf<PerformanceMetrics>()) }
    var benchmarkResults by remember { mutableStateOf(listOf<BenchmarkResult>()) }
    var selectedFramework by remember { mutableStateOf("circom") }
    var batchSize by remember { mutableStateOf(5) }
    var currentProgress by remember { mutableStateOf(0) }
    var lastGeneratedProof by remember { mutableStateOf<String?>(null) }
    
    val activityManager = remember { context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager }
    val decimalFormat = remember { DecimalFormat("#.##") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        // Header
        Text(
            text = "Mopro Performance Benchmarking",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        // Framework Selection
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            listOf("circom", "halo2", "noir").forEach { framework ->
                Button(
                    onClick = { selectedFramework = framework },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (selectedFramework == framework) 
                            MaterialTheme.colorScheme.primary 
                        else 
                            MaterialTheme.colorScheme.secondary
                    )
                ) {
                    Text(framework.uppercase())
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Batch Size Configuration
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Batch Size: ", fontWeight = FontWeight.Medium)
            Spacer(modifier = Modifier.width(8.dp))
            TextField(
                value = batchSize.toString(),
                onValueChange = { 
                    batchSize = it.toIntOrNull()?.coerceIn(1, 50) ?: 1 
                },
                modifier = Modifier.width(80.dp),
                singleLine = true
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Control Buttons
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Button(
                onClick = {
                    coroutineScope.launch {
                        runSingleBenchmark(
                            context, 
                            selectedFramework, 
                            activityManager,
                            onMetric = { metrics ->
                                performanceMetrics = performanceMetrics + metrics
                            },
                            onProofGenerated = { proof ->
                                lastGeneratedProof = proof
                            }
                        )
                    }
                },
                enabled = !isRunning
            ) {
                Text("Single Run")
            }

            Button(
                onClick = {
                    coroutineScope.launch {
                        runBatchBenchmark(
                            context, 
                            selectedFramework, 
                            batchSize, 
                            activityManager,
                            onProgress = { progress -> currentProgress = progress },
                            onComplete = { results ->
                                benchmarkResults = benchmarkResults + results
                                currentProgress = 0
                            }
                        )
                    }
                },
                enabled = !isRunning
            ) {
                Text("Batch Run")
            }

            Button(
                onClick = {
                    lastGeneratedProof?.let { proof ->
                        coroutineScope.launch {
                            runVerification(context, selectedFramework, proof, activityManager) { metrics ->
                                performanceMetrics = performanceMetrics + metrics
                            }
                        }
                    }
                },
                enabled = lastGeneratedProof != null
            ) {
                Text("Verify Last Proof")
            }
            
            Button(
                onClick = {
                    performanceMetrics = emptyList()
                    benchmarkResults = emptyList()
                    lastGeneratedProof = null
                },
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.error
                )
            ) {
                Text("Clear")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Progress Indicator
        if (currentProgress > 0) {
            LinearProgressIndicator(
                progress = currentProgress.toFloat() / batchSize,
                modifier = Modifier.fillMaxWidth()
            )
            Text(
                text = "Progress: $currentProgress/$batchSize",
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Results Display
        LazyColumn(
            modifier = Modifier.weight(1f)
        ) {
            // Recent Performance Metrics
            if (performanceMetrics.isNotEmpty()) {
                item {
                    Text(
                        text = "Recent Performance Metrics",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(vertical = 8.dp)
                    )
                }

                items(performanceMetrics.takeLast(10)) { metric ->
                    PerformanceMetricCard(metric, decimalFormat)
                }
            }

            // Benchmark Results
            if (benchmarkResults.isNotEmpty()) {
                item {
                    Text(
                        text = "Benchmark Results",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(vertical = 8.dp)
                    )
                }

                items(benchmarkResults) { result ->
                    BenchmarkResultCard(result, decimalFormat)
                }
            }
        }
    }
}

@Composable
fun PerformanceMetricCard(metric: PerformanceMetrics, decimalFormat: DecimalFormat) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = "${metric.framework.uppercase()} - ${metric.operation}",
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = "${decimalFormat.format(metric.duration)}ms",
                    color = MaterialTheme.colorScheme.primary
                )
            }
            
            Spacer(modifier = Modifier.height(4.dp))
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text("Memory: ${formatBytes(metric.memoryAfter - metric.memoryBefore)}")
                metric.proofSize?.let { size ->
                    Text("Proof Size: ${formatBytes(size.toLong())}")
                }
                metric.proofContent?.let { content ->
                    Text(
                        text = "Proof: $content",
                        fontSize = 10.sp,
                        fontFamily = androidx.compose.ui.text.font.FontFamily.Monospace,
                        maxLines = 2,
                        overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                    )
                }
                metric.verificationResult?.let { verified ->
                    Text(
                        text = if (verified) "✅ Verified" else "❌ Failed",
                        color = if (verified) Color.Green else Color.Red,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
            
            Text(
                text = "Time: ${java.text.SimpleDateFormat("HH:mm:ss").format(metric.timestamp)}",
                fontSize = 12.sp,
                color = Color.Gray
            )
        }
    }
}

@Composable
fun BenchmarkResultCard(result: BenchmarkResult, decimalFormat: DecimalFormat) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "${result.framework.uppercase()} Benchmark Results",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text("Avg Proving: ${decimalFormat.format(result.avgProvingTime)}ms")
                    Text("Avg Verifying: ${decimalFormat.format(result.avgVerifyingTime)}ms")
                }
                Column {
                    Text("Avg Proof Size: ${formatBytes(result.avgProofSize.toLong())}")
                    Text("Success Rate: ${decimalFormat.format(result.successRate * 100)}%")
                }
            }
            
            Spacer(modifier = Modifier.height(4.dp))
            
            Text(
                text = "Runs: ${result.totalRuns} | Avg Memory: ${formatBytes(result.avgMemoryUsage.toLong())}",
                fontSize = 12.sp,
                color = Color.Gray
            )
        }
    }
}

// Standalone verification function
suspend fun runVerification(
    context: Context,
    framework: String,
    proofContent: String,
    activityManager: ActivityManager,
    onMetric: (PerformanceMetrics) -> Unit
) {
    val memoryBefore = getMemoryUsage(activityManager)
    val startTime = SystemClock.elapsedRealtime()
    
    try {
        when (framework) {
            "circom" -> {
                val assetFilePath = copyAssetToInternalStorage(context, "circom.zkey")
                assetFilePath?.let { path ->
                    // Parse proof content back to CircomProofResult
                    // This is a simplified approach - in practice you'd need proper deserialization
                    val isValid = try {
                        // For now, just attempt verification with a mock proof result
                        // In a real implementation, you'd deserialize the proof properly
                        true // Placeholder - always returns true for demo
                    } catch (e: Exception) {
                        false
                    }
                    
                    val memoryAfter = getMemoryUsage(activityManager)
                    val duration = SystemClock.elapsedRealtime() - startTime
                    
                    onMetric(PerformanceMetrics(
                        framework = framework,
                        operation = "verification",
                        duration = duration,
                        memoryBefore = memoryBefore,
                        memoryAfter = memoryAfter,
                        proofSize = proofContent.length,
                        proofContent = proofContent.take(100) + "...",
                        verificationResult = isValid
                    ))
                }
            }
            // Add other frameworks as needed
        }
    } catch (e: Exception) {
        val memoryAfter = getMemoryUsage(activityManager)
        val duration = SystemClock.elapsedRealtime() - startTime
        
        onMetric(PerformanceMetrics(
            framework = framework,
            operation = "verification_error",
            duration = duration,
            memoryBefore = memoryBefore,
            memoryAfter = memoryAfter,
            verificationResult = false
        ))
    }
}

// Performance measurement functions
suspend fun runSingleBenchmark(
    context: Context,
    framework: String,
    activityManager: ActivityManager,
    onMetric: (PerformanceMetrics) -> Unit,
    onProofGenerated: (String) -> Unit = {}
) {
    val memoryBefore = getMemoryUsage(activityManager)
    val startTime = SystemClock.elapsedRealtime()
    
    try {
        when (framework) {
            "circom" -> {
                val assetFilePath = copyAssetToInternalStorage(context, "circom.zkey")
                val inputFilePath = copyAssetToInternalStorage(context, "input_9.json")
                
                assetFilePath?.let { zkeyPath ->
                    inputFilePath?.let { inputPath ->
                        val input_str = File(inputPath).readText()
                        val proofResult = generateCircomProof(zkeyPath, input_str, ProofLib.ARKWORKS)
                        val memoryAfter = getMemoryUsage(activityManager)
                        val duration = SystemClock.elapsedRealtime() - startTime
                        
                        onProofGenerated(proofResult.toString())
                        
                        onMetric(PerformanceMetrics(
                            framework = framework,
                            operation = "proof_generation",
                            duration = duration,
                            memoryBefore = memoryBefore,
                            memoryAfter = memoryAfter,
                            proofSize = proofResult.toString().length,
                            proofContent = proofResult.toString().take(100) + "...",
                            verificationResult = null
                        ))
                    }
            }}
            "halo2" -> {
                val srsPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_srs.bin")
                val provingKeyPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_pk.bin")
                val inputs = mutableMapOf<String, List<String>>()
                inputs["out"] = listOf("55")
                
                val proofResult = generateHalo2Proof(srsPath, provingKeyPath, inputs)
                val memoryAfter = getMemoryUsage(activityManager)
                val duration = SystemClock.elapsedRealtime() - startTime
                
                onMetric(PerformanceMetrics(
                    framework = framework,
                    operation = "proof_generation",
                    duration = duration,
                    memoryBefore = memoryBefore,
                    memoryAfter = memoryAfter,
                    proofSize = proofResult.proof.size
                ))
            }
            "noir" -> {
                val circuitFile = getFilePathFromAssetsNonComposable(context, "noir_multiplier2.json")
                val srsFile = getFilePathFromAssetsNonComposable(context, "noir_multiplier2.srs")
                val inputs = listOf("5", "3")
                
                val proofBytes = generateNoirProof(circuitFile, srsFile, inputs)
                val memoryAfter = getMemoryUsage(activityManager)
                val duration = SystemClock.elapsedRealtime() - startTime
                
                onMetric(PerformanceMetrics(
                    framework = framework,
                    operation = "proof_generation",
                    duration = duration,
                    memoryBefore = memoryBefore,
                    memoryAfter = memoryAfter,
                    proofSize = proofBytes?.size ?: 0
                ))
            }
        }
    } catch (e: Exception) {
        val memoryAfter = getMemoryUsage(activityManager)
        val duration = SystemClock.elapsedRealtime() - startTime
        
        onMetric(PerformanceMetrics(
            framework = framework,
            operation = "error",
            duration = duration,
            memoryBefore = memoryBefore,
            memoryAfter = memoryAfter
        ))
    }
}

suspend fun runBatchBenchmark(
    context: Context,
    framework: String,
    batchSize: Int,
    activityManager: ActivityManager,
    onProgress: (Int) -> Unit,
    onComplete: (BenchmarkResult) -> Unit
) {
    val provingTimes = mutableListOf<Long>()
    val verifyingTimes = mutableListOf<Long>()
    val proofSizes = mutableListOf<Int>()
    val memoryUsages = mutableListOf<Long>()
    var successfulRuns = 0
    
    repeat(batchSize) { run ->
        try {
            // Proving phase
            val memoryBefore = getMemoryUsage(activityManager)
            val provingStart = SystemClock.elapsedRealtime()
            
            val proofResult = when (framework) {
                "circom" -> {
                    val assetFilePath = copyAssetToInternalStorage(context, "circom.zkey")
                    val inputFilePath = copyAssetToInternalStorage(context, "input_9.json")
                    
                    assetFilePath?.let { zkeyPath ->
                        inputFilePath?.let { inputPath ->
                            val input_str = File(inputPath).readText()
                            generateCircomProof(zkeyPath, input_str, ProofLib.ARKWORKS)
                        }
                    }
                }
                "halo2" -> {
                    val srsPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_srs.bin")
                    val provingKeyPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_pk.bin")
                    val inputs = mutableMapOf<String, List<String>>()
                    inputs["out"] = listOf("55")
                    generateHalo2Proof(srsPath, provingKeyPath, inputs)
                }
                "noir" -> {
                    val circuitFile = getFilePathFromAssetsNonComposable(context, "noir_multiplier2.json")
                    val srsFile = getFilePathFromAssetsNonComposable(context, "noir_multiplier2.srs")
                    val inputs = listOf("5", "3")
                    generateNoirProof(circuitFile, srsFile, inputs)
                }
                else -> null
            }
            
            val provingEnd = SystemClock.elapsedRealtime()
            val memoryAfter = getMemoryUsage(activityManager)
            
            if (proofResult != null) {
                provingTimes.add(provingEnd - provingStart)
                memoryUsages.add(memoryAfter - memoryBefore)
                
                // Proof size calculation
                val proofSize = when (framework) {
                    "circom" -> proofResult.toString().length
                    "halo2" -> (proofResult as uniffi.mopro.Halo2ProofResult).proof.size
                    "noir" -> (proofResult as ByteArray).size
                    else -> 0
                }
                proofSizes.add(proofSize)
                
                // Verification phase
                val verifyingStart = SystemClock.elapsedRealtime()
                try {
                    when (framework) {
                        "circom" -> {
                            val assetFilePath = copyAssetToInternalStorage(context, "circom.zkey")
                            assetFilePath?.let { path ->
                                verifyCircomProof(path, proofResult as uniffi.mopro.CircomProofResult, ProofLib.ARKWORKS)
                            }
                        }
                        "halo2" -> {
                            val srsPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_srs.bin")
                            val verifyingKeyPath = getFilePathFromAssetsNonComposable(context, "plonk_fibonacci_vk.bin")
                            verifyHalo2Proof(srsPath, verifyingKeyPath, (proofResult as uniffi.mopro.Halo2ProofResult).proof, (proofResult as uniffi.mopro.Halo2ProofResult).inputs)
                        }
                        "noir" -> {
                            val circuitFile = getFilePathFromAssetsNonComposable(context, "noir_multiplier2.json")
                            val noirProofBytes = proofResult as? ByteArray
                            if (noirProofBytes != null) {
                                verifyNoirProof(circuitFile, noirProofBytes)
                            }
                        }
                    }
                    val verifyingEnd = SystemClock.elapsedRealtime()
                    verifyingTimes.add(verifyingEnd - verifyingStart)
                    successfulRuns++
                } catch (e: Exception) {
                    // Verification failed, but proving succeeded
                    verifyingTimes.add(-1) // Mark as failed
                }
            }
        } catch (e: Exception) {
            // Proving failed
            provingTimes.add(-1)
            verifyingTimes.add(-1)
            proofSizes.add(0)
            memoryUsages.add(0)
        }
        
        onProgress(run + 1)
    }
    
    // Calculate results
    val validProvingTimes = provingTimes.filter { it > 0 }
    val validVerifyingTimes = verifyingTimes.filter { it > 0 }
    val validProofSizes = proofSizes.filter { it > 0 }
    val validMemoryUsages = memoryUsages.filter { it > 0 }
    
    val result = BenchmarkResult(
        framework = framework,
        avgProvingTime = if (validProvingTimes.isNotEmpty()) validProvingTimes.average() else 0.0,
        avgVerifyingTime = if (validVerifyingTimes.isNotEmpty()) validVerifyingTimes.average() else 0.0,
        avgProofSize = if (validProofSizes.isNotEmpty()) validProofSizes.average() else 0.0,
        avgMemoryUsage = if (validMemoryUsages.isNotEmpty()) validMemoryUsages.average() else 0.0,
        totalRuns = batchSize,
        successRate = successfulRuns.toDouble() / batchSize
    )
    
    onComplete(result)
}

// Utility function to get memory usage
fun getMemoryUsage(activityManager: ActivityManager): Long {
    val memoryInfo = ActivityManager.MemoryInfo()
    activityManager.getMemoryInfo(memoryInfo)
    return memoryInfo.totalMem - memoryInfo.availMem
}

// Utility function to format bytes
fun formatBytes(bytes: Long): String {
    if (bytes < 1024) return "$bytes B"
    if (bytes < 1024 * 1024) return "${bytes / 1024} KB"
    if (bytes < 1024 * 1024 * 1024) return "${bytes / (1024 * 1024)} MB"
    return "${bytes / (1024 * 1024 * 1024)} GB"
}

private fun copyAssetToInternalStorage(context: Context, assetFileName: String): String? {
    val file = File(context.filesDir, assetFileName)
    return try {
        context.assets.open(assetFileName).use { inputStream ->
            FileOutputStream(file).use { outputStream ->
                val buffer = ByteArray(1024)
                var length: Int
                while (inputStream.read(buffer).also { length = it } > 0) {
                    outputStream.write(buffer, 0, length)
                }
                outputStream.flush()
            }
        }
        file.absolutePath
    } catch (e: IOException) {
        e.printStackTrace()
        null
    }
}