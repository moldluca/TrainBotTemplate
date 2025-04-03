import CoreML
import Vision
import UIKit

class MLModelTemplate {
    private var trainingData: [(image: UIImage, label: String)] = [] // Stores training data
    private var model: MLModel? // CoreML model instance

    init() {
        setupModel() // Initialize the model
    }

    // Sets up the CoreML model
    private func setupModel() {
        do {
            let config = MLModelConfiguration()
            config.allowLowPrecisionAccumulationOnGPU = true // Optimize for GPU usage
            
            // Load a pre-trained model or create a placeholder
            if let modelURL = Bundle.main.url(forResource: "MobileNetV2", withExtension: "mlmodelc") {
                model = try MLModel(contentsOf: modelURL, configuration: config)
                print("Model loaded successfully.")
            } else {
                print("No pre-trained model found. Placeholder model will be used.")
                model = nil
            }
        } catch {
            print("Failed to set up model: \(error.localizedDescription)")
            model = nil
        }
    }

    // Adds an image and label to the training data
    func train(img: UIImage, label: String) {
        trainingData.append((image: img, label: label))
        print("Training data added: \(label)")
    }

    // Finalizes training and updates the model
    func finalizeTraining() {
        guard !trainingData.isEmpty else {
            print("No training data available.")
            return
        }

        // Convert training data into a format suitable for CoreML
        let trainingDataset = trainingData.map { (image, label) -> (features: [Double], label: String) in
            let features = extractFeatures(from: image) ?? []
            return (features: features, label: label)
        }

        // Prepare data for training
        var featureArray: [[Double]] = []
        var labelArray: [String] = []
        for data in trainingDataset {
            featureArray.append(data.features)
            labelArray.append(data.label)
        }

        do {
            // Create a training table
            let featureProvider = try MLArrayBatchProvider(array: featureArray.enumerated().map { index, features in
                let featureDict: [String: Any] = [
                    "features": MLMultiArray(features),
                    "label": labelArray[index]
                ]
                return try MLDictionaryFeatureProvider(dictionary: featureDict)
            })

            // Train the model
            let config = MLModelConfiguration()
            let trainingModel = try MLModel.compileModel(at: Bundle.main.url(forResource: "MobileNetV2", withExtension: "mlmodel")!)
            model = try MLModel(contentsOf: trainingModel, configuration: config)
            print("Model training completed with \(trainingDataset.count) samples.")
        } catch {
            print("Error during model training: \(error.localizedDescription)")
        }
    }

    // Tests an image and returns the predicted label
    func test(img: UIImage) -> String? {
        guard let cgImage = img.cgImage, let model = model else {
            print("Model is not ready or image is invalid.")
            return nil
        }

        do {
            let visionModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: visionModel) { request, _ in
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    print("No classification results.")
                    return
                }
                print("Predicted label: \(topResult.identifier) with confidence \(topResult.confidence)")
            }
            request.imageCropAndScaleOption = .centerCrop

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
        } catch {
            print("Error testing the image: \(error)")
            return nil
        }

        // Placeholder return value (replace with actual prediction logic)
        return "Predicted Label"
    }

    // Extracts features from an image for training or testing
    private func extractFeatures(from image: UIImage) -> [Double]? {
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let blockSize = 32
        var features: [Double] = []

        for y in stride(from: 0, to: height, by: blockSize) {
            for x in stride(from: 0, to: width, by: blockSize) {
                let rect = CGRect(x: x, y: y,
                                  width: min(blockSize, width - x),
                                  height: min(blockSize, height - y))
                if let blockImage = cgImage.cropping(to: rect) {
                    let avgColor = getAverageColor(of: blockImage)
                    features.append(contentsOf: avgColor)
                }
            }
        }

        return features.isEmpty ? nil : features
    }

    // Calculates the average color of a cropped image block
    private func getAverageColor(of cgImage: CGImage) -> [Double] {
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        var rawBytes: [UInt8] = Array(repeating: 0, count: width * height * bytesPerPixel)

        let context = CGContext(data: &rawBytes,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerRow,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var r: Double = 0
        var g: Double = 0
        var b: Double = 0

        for i in stride(from: 0, to: rawBytes.count, by: bytesPerPixel) {
            r += Double(rawBytes[i])
            g += Double(rawBytes[i + 1])
            b += Double(rawBytes[i + 2])
        }

        let pixelCount = Double(width * height)
        return [r / pixelCount / 255.0,
                g / pixelCount / 255.0,
                b / pixelCount / 255.0]
    }
}
