import Foundation

class AppSettings {
    static let shared = AppSettings()
    private let userDefaults = UserDefaults.standard

    private init() {}

    // Sets a value for a given key
    func setValue(_ value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    // Retrieves a value for a given key
    func getValue(forKey key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }

    // Resets all settings
    func resetSettings() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        print("All settings have been reset.")
    }
}
