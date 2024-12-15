class AuthService {
  static String? _currentUser;
  static Map<String, String> _users = {}; // In-memory user storage

  // Simulate sign-up
  static Future<bool> signup(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    if (_users.containsKey(email)) {
      return false; // User already exists
    }

    _users[email] = password; // Store user email and password
    _currentUser = email;
    return true; // Sign-up successful
  }

  // Simulate login
  static Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    if (_users[email] == password) {
      _currentUser = email; // Set the logged-in user
      return true;
    }
    return false;
  }

  // Check if user is authenticated
  static bool get isAuthenticated => _currentUser != null;

  // Get the current logged-in user
  static String? get currentUser => _currentUser;

  // Simulate logout
  static void logout() {
    _currentUser = null;
  }
}
