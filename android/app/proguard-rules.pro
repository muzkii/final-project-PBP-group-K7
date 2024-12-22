# Keep Google ErrorProne annotations
-keep class com.google.errorprone.annotations.** { *; }

# Keep javax.annotation classes
-keep class javax.annotation.** { *; }

# Keep javax.lang.model classes
-keep class javax.lang.model.** { *; }

# Keep enum constants for javax.lang.model.element.Modifier
-keepclassmembers enum javax.lang.model.element.Modifier { *; }

# Don't warn about missing javax.annotation or javax.lang.model classes
-dontwarn javax.annotation.**
-dontwarn javax.lang.model.**

# Keep Guava classes (optional, if minification breaks its functionality)
-keep class com.google.common.** { *; }

# Suppress warnings for AnnotatedType
-dontwarn java.lang.reflect.AnnotatedType
