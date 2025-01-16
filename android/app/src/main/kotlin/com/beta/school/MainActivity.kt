package com.beta.school

import android.os.Bundle
//import android.view.WindowManager
import android.content.Intent
import android.net.Uri
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Prevent screenshots and screen recording
//         window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)

        // Handle deep link when activity is created
        handleDeepLink(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)  // Make sure the new intent is set
        handleDeepLink(intent)
    }

    private fun handleDeepLink(intent: Intent) {
    val data: Uri? = intent.data
    if (data != null) {
        // Log the full URL to make sure it's what you expect
        println("Received deep link: ${data.toString()}")

        val token = data.getQueryParameter("token")
        if (token != null) {
            // Token found
            println("Received token: $token")
            // You can now use the token to navigate to the reset-password screen or handle logic
        } else {
            // Token not found, log it
            println("No token found in the deep link")
        }
    } else {
        println("No data found in the intent")
    }
}
}
