package com.fiftyonecash.fifty_one_cash
import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import androidx.appcompat.app.AppCompatDelegate
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Set the default theme to light mode
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);

    }
}
