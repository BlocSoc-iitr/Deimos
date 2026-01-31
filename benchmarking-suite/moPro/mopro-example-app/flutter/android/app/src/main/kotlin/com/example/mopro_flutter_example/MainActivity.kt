package com.example.mopro_flutter_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.mopro_flutter_example.channels.IMP1ProverChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register IMP1 prover channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            IMP1ProverChannel.CHANNEL_NAME
        ).setMethodCallHandler(IMP1ProverChannel(this))
    }
}
