import UIKit

class TrainingView: UIViewController {
    private let imageView = UIImageView()
    private let labelField = UITextField()
    private let addButton = UIButton(type: .system)
    private let trainButton = UIButton(type: .system)
    private let modelTemplate = MLModelTemplate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Configure image view
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Configure label field
        labelField.placeholder = "Enter label"
        labelField.borderStyle = .roundedRect
        labelField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelField)

        // Configure add button
        addButton.setTitle("Add Training Data", for: .normal)
        addButton.addTarget(self, action: #selector(addTrainingData), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // Configure train button
        trainButton.setTitle("Train Model", for: .normal)
        trainButton.addTarget(self, action: #selector(trainModel), for: .touchUpInside)
        trainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trainButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            labelField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            labelField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelField.widthAnchor.constraint(equalToConstant: 200),

            addButton.topAnchor.constraint(equalTo: labelField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            trainButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            trainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func addTrainingData() {
        guard let label = labelField.text, !label.isEmpty else {
            print("Label is empty.")
            return
        }

        // Simulate adding an image (replace with actual image picker logic)
        let dummyImage = UIImage(named: "placeholder") ?? UIImage()
        modelTemplate.train(img: dummyImage, label: label)
        print("Training data added: \(label)")
    }

    @objc private func trainModel() {
        modelTemplate.finalizeTraining()
    }
}
