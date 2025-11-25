-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

########### AndroidX and Google dependencies ###########
-keep class androidx.** { *; }
-keep class com.google.** { *; }
-dontwarn androidx.**
-dontwarn com.google.**

########### Cashfree SDK ###########
-keep class com.cashfree.pg.** { *; }
-dontwarn com.cashfree.pg.**
-keep class com.cashfree.pg.api.** { *; }
-keep class com.cashfree.pg.core.** { *; }
-keep class com.cashfree.pg.ui.** { *; }

########### Gson / JSON Parsing ###########
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

########### Kotlin (if using Kotlin code) ###########
-keep class kotlin.** { *; }
-dontwarn kotlin.**