import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var characters = [Character]()
    var attackerIndex = 0
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.borderStyle = .bezel
        field.placeholder = ""
        field.font = .systemFont(ofSize: 30)
        return field
    }()
    
    lazy var addCharacterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(addCharacter), for: .touchUpInside)
        return button
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(performAttack), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    lazy var eventLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    private func setUI() {
        view.addSubview(textField)
        view.addSubview(addCharacterButton)
        view.addSubview(startButton)
        view.addSubview(scrollView)
        scrollView.addSubview(eventLabel)
        view.addSubview(nameLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.leading.equalToSuperview().inset(25)
        }
        
        addCharacterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().inset(25)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(250)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-25)
        }
        
        eventLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(370)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    @objc private func addCharacter() {
        if let name = textField.text, !name.isEmpty {
            let health = Int.random(in: 100...300)
            let damage = Int.random(in: 20...40)
            let character = Character(name: name, health: health, damage: damage)
            characters.append(character)
            updateNameLabel()
            textField.text = ""
        }
    }
    
    @objc private func performAttack() {
        let attacker = characters[attackerIndex]
        let nextCharacterIndex = (attackerIndex + 1) % characters.count
        var target = characters[nextCharacterIndex]
        
        target.health -= attacker.damage
        
        if target.health <= 0 {
            eventLabel.text! += "\(attacker.name) победил \(target.name)!\n"
            characters.remove(at: nextCharacterIndex)
            
            if characters.count == 1 {
                eventLabel.text! += "\(characters[0].name) - победитель!\n"
                startButton.isEnabled = false
            }
        } else {
            eventLabel.text! += "\(attacker.name) атаковал \(target.name). \nЗдоровье \(target.name): \(target.health)\n"
            
            attackerIndex = (attackerIndex + 1) % characters.count
        }
        
        updateNameLabel()
    }

    private func updateNameLabel() {
        var namesString = "Characters: "
        for character in characters {
            namesString += character.name + ", "
        }
        if !characters.isEmpty {
            namesString.removeLast(2)
        }
        nameLabel.text = namesString
    }
}
