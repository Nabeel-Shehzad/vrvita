// lib/global.dart
library globals;

/// الدور الحالي للمستخدم (بعد الاختيار من RolePage أو بعد التسجيل)
/// القيم المتوقعة: "doctor" | "student" | "nurse" | "supervisor"
String TypeUser = '';

/// هل المستخدم يملك حسابًا (تم التسجيل سابقًا)؟
/// تبقى true بعد أول تسجيل ناجح ولا تُعاد إلى false عند تسجيل الخروج.
bool isSignedUp = false;

/// هل المستخدم مسجّل الدخول حاليًا (جلسة فعّالة)؟
bool isLoggedIn = false;

/// الـ ID الذي سجّل به المستخدم (9 أرقام)
String registeredId = '';

/// الاسم المعروض للمستخدم بعد التسجيل/الدخول
String userDisplayName = '';

/// هل فضّل المستخدم الدخول بالبصمة (Face/Touch ID)؟
bool biometricEnabled = false;

/// إعادة التهيئة عند **تسجيل الخروج فقط**
/// لا تلمس isSignedUp حتى لا يُطلَب Sign Up من جديد.
/// امسح معلومات الجلسة وما يحتاج يُعاد كل مرة.
void resetSession() {
  isLoggedIn = false;   // خرج من الجلسة
  // ممكن تفضلي تُبقي الدور والاسم حسب تصميمك:
  // TypeUser = '';      // ← امسحيه فقط إذا تبين إجبار اختيار الدور كل مرة
  // userDisplayName = '';
  // لا تلمسي registeredId ولا isSignedUp ولا biometricEnabled هنا
}

/// إعادة التهيئة الكاملة (استخدميها فقط لو تبين مسح الحساب كليًا)
void resetAllAccount() {
  TypeUser = '';
  isSignedUp = false;     // إلغاء وجود الحساب
  isLoggedIn = false;
  registeredId = '';
  userDisplayName = '';
  biometricEnabled = false;
}

