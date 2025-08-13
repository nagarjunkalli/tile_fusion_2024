# Flutter specific ProGuard rules
# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Dart VM service classes
-keep class io.flutter.embedding.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep shared preferences
-keep class androidx.preference.** { *; }

# Keep URL launcher plugin classes
-keep class io.flutter.plugins.urllauncher.** { *; }

# Don't warn about missing classes
-dontwarn io.flutter.**