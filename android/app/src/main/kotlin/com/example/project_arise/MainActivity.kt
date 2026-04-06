package com.example.project_arise

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.firebase.appdistribution.FirebaseAppDistribution
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.project_arise/feedback"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startFeedback") {
                try {
                    FirebaseAppDistribution.getInstance().startFeedback("Report an issue or give feedback")
                    result.success(null)
                    println("===== 🚀 SHAKE NATIVE TRIGGERED! =====")
                } catch (e: Exception) {
                    Log.e("FeedbackChannel", "Failed to trigger Firebase Feedback", e)
                    result.error("FEEDBACK_ERROR", e.message, null)
                    println("===== 🚀 SHAKE NATIVE TRIGGERED! =====")
                }
            } else {
                println("===== 🚀 SHAKE NATIVE TRIGGERED! =====")
                result.notImplemented()
            }
        }
    }
}
