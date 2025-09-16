plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.infyapp"

    defaultConfig {
        applicationId = "com.example.infyapp"
        minSdk = flutter.minSdkVersion
    }

    buildTypes {
        release {
        }
    }
}

flutter {
    source = "../.."
}
