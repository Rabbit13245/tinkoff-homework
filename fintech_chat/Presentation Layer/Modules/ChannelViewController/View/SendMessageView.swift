import UIKit

class SendMessageView: AppTextWrapperView {
    
    // MARK: - UI
    
    lazy var inputTextView: AppChatTextView = {
        let textView = AppChatTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Your message here..."
        textView.textColor = UIColor.lightGray

        // textView.delegate = self

        textView.layer.cornerRadius = 16

        return textView
    }()
    
    private lazy var addItemsButton: UIButton = {
        let buttonAdd = UIButton(type: .contactAdd)
        
        return buttonAdd
    }()
    
    lazy var buttonSend: UIButton = {
        let buttonSend = UIButton(type: .roundedRect)
        buttonSend.setTitle("Send", for: .normal)
        
        //buttonSend
        
        buttonSend.isEnabled = false
        
        return buttonSend
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [addItemsButton, inputTextView, buttonSend])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.5),

            inputTextView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
