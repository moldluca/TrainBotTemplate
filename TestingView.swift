import UIKit

class TestingView: UIViewController {
    private let imageView = UIImageView()
    private let testButton = UIButton(type: .system)
    private let resultLabel = UILabel()
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

        // Configure test button
        testButton.setTitle("Test Image", for: .normal)
        testButton.addTarget(self, action: #selector(testImage), for: .touchUpInside)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)

        // Configure result label
        resultLabel.text = "Result: "
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)

        // Layout constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            testButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resultLabel.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc private func testImage() {
        // Simulate testing an image (replace with actual image picker logic)
        let dummyImage = UIImage(named: "placeholder") ?? UIImage()
        if let result = modelTemplate.test(img: dummyImage) {
            resultLabel.text = "Result: \(result)"
        } else {
            resultLabel.text = "Result: Error"
        }
    }
}
