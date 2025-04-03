import Foundation

class AchievementsManager {
    static let shared = AchievementsManager()
    private var achievements: [String: Bool] = [:]

    private init() {}

    // Unlocks an achievement
    func unlockAchievement(_ name: String) {
        achievements[name] = true
        print("Achievement unlocked: \(name)")
    }

    // Checks if an achievement is unlocked
    func isAchievementUnlocked(_ name: String) -> Bool {
        return achievements[name] ?? false
    }

    // Lists all unlocked achievements
    func listUnlockedAchievements() -> [String] {
        return achievements.filter { $0.value }.map { $0.key }
    }
}
