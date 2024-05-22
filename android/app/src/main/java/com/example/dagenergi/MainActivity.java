package com.example.dagenergi;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin;


public class MainActivity extends FlutterActivity {
     @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        FlutterForegroundTaskPlugin.setPluginRegistrant(this);
    }
}

