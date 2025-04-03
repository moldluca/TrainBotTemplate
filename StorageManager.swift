import Foundation
import UIKit

class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default
    private let trainingDataURL: URL

    private init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        trainingDataURL = documentsDirectory.appendingPathComponent("trainingData.json")
    }

    // Saves training data to disk
    func saveTrainingData(_ data: [(image: UIImage, label: String)]) {
        let encodedData = data.compactMap { item -> [String: Any]? in
            guard let imageData = item.image.jpegData(compressionQuality: 0.8) else { return nil }
            return ["image": imageData.base64EncodedString(), "label": item.label]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: encodedData, options: [])
            try jsonData.write(to: trainingDataURL)
            print("Training data saved successfully.")
        } catch {
            print("Failed to save training data: \(error.localizedDescription)")
        }
    }

    // Loads training data from disk
    func loadTrainingData() -> [(image: UIImage, label: String)] {
        do {
            let jsonData = try Data(contentsOf: trainingDataURL)
            guard let decodedArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else { return [] }

            return decodedArray.compactMap { item in
                guard let imageString = item["image"] as? String,
                      let imageData = Data(base64Encoded: imageString),
                      let image = UIImage(data: imageData),
                      let label = item["label"] as? String else { return nil }
                return (image: image, label: label)
            }
        } catch {
            print("Failed to load training data: \(error.localizedDescription)")
            return []
        }
    }
}
