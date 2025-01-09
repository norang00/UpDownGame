//
//  ViewController.swift
//  UpDownGame
//
//  Created by Kyuhee hong on 1/9/25.
//

import UIKit

class ViewController: UIViewController {

    var numberList: [Int] = []
    var listStartNumber: Int = 1
    var listEndNumber: Int = 0
    var randomNumber: Int = 0
    var guessNumber: Int = 0
    var tryCountNumber: Int = 0

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tryCountLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var resultButton: UIButton!
    
    static let sectionInset: CGFloat = 24
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
    }

    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /* [고민한 부분]
     레이아웃이 비슷한 View 를 재사용 하고 싶다고 생각했다.
     1. 커버한 이미지를 isHidden = true 로 했는데 컬렉션 아이템들을 선택할 수 없었다.
     탭 제스처 때문일까 하고 이미지뷰에 링크를 했는데 제대로 작동하지 않았다.
     -> UserInteraction 때문이었다! 수업에 들었는데 그대로..
     2. 하나의 파일에 관련 로직을 모두 구현하는 중인데 너무 길어지는 것 같다.
     뷰 자체는 재사용하되 로직 파일들을 분리하는 것이 좋을까 생각이 되는데 적절한 방법인지 모르겠다.
     */

}

// MARK: - Views Design 설정
extension ViewController {
    
    func configureView() {
        view.backgroundColor = .banana
        
        titleLabel.text = "UP DOWN"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 40, weight: .black)
        titleLabel.numberOfLines = 1
        titleLabel.frame.size = titleLabel.intrinsicContentSize
        
        tryCountLabel.text = "GAME"
        tryCountLabel.textColor = .gray
        tryCountLabel.textAlignment = .center
        tryCountLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        tryCountLabel.numberOfLines = 1
        tryCountLabel.frame.size = tryCountLabel.intrinsicContentSize
        tryCountLabel.contentMode = .top

        coverImageView.isHidden = false
        coverImageView.backgroundColor = .banana
        coverImageView.image = UIImage(named: "updown")
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.isUserInteractionEnabled = true
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: inputTextField.frame.height))
        inputTextField.leftView = padding
        inputTextField.leftViewMode = .always
        inputTextField.placeholder = "  숫자를 입력해보세요!"
        inputTextField.borderStyle = .line
        inputTextField.backgroundColor = .white
        inputTextField.keyboardType = .numberPad
        inputTextField.layer.borderWidth = 3
        inputTextField.font = .systemFont(ofSize: 16, weight: .medium)
        inputTextField.isHidden = false
        
        resultButton.setTitle("시작하기", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.setTitleColor(.lightGray, for: .disabled)
        resultButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        resultButton.layer.cornerRadius = 16
        resultButton.layer.backgroundColor = UIColor.black.cgColor
        resultButton.isEnabled = false
    }
    
//    func setViewLinkedWithStatus() {
//        titleLabel.text = "UP DOWN"
//        tryCountLabel.textColor = isStarted ?  .black : .gray
//        tryCountLabel.text = isStarted ? "시도 횟수: \(tryCountNumber)" : "GAME"
//        coverImageView.isHidden = isStarted
//        resultButton.setTitle(isStarted ? "결과 확인하기" : "시작하기", for: .normal)
//        resultButton.isEnabled = !((inputTextField.text?.isEmpty) != nil)
//        resultButton.backgroundColor = resultButton.isEnabled ? .black : .gray
//    }
    /* [고민되는 부분]
     상태값에 따라 달라지는 View 요소들을 모아서 한번에 갱신할 수 있게 해봤는데, 요소별로 불필요한 것들도 있었다.
     버튼 텍스트 같은 경우에는 바뀌기 전에 항상 트리거가 있어서 적절하게 바꿔줄 수 있는 타이밍이 있었다.
     무리하게 삼항연산자 사용하지 않아도 될 것 같기도 하고... 스유의 스테이트 바인딩이 그리워지는 저녁이다..
     */
}

// MARK: - Game 상태 관련 로직
extension ViewController {
    
    func setStandbyStatus() {
        titleLabel.text = "UP DOWN"
        tryCountLabel.textColor = .gray
        tryCountLabel.text = "GAME"
        coverImageView.isHidden = false
        inputTextField.text = ""
        inputTextField.isHidden = false
        resultButton.setTitle("시작하기", for: .normal)
        resultButton.isEnabled = false
        
        numberList = []
        listStartNumber = 1
        listEndNumber = 0
        randomNumber = 0
        guessNumber = 0
        tryCountNumber = 0
    }
    /* [고민]
     초기화... 상태값 관리... 이게 최선일까??
     */
    
    func setInGameStatus() {
        titleLabel.text = "UP DOWN"
        tryCountLabel.textColor = .black
        tryCountLabel.text = "시도 횟수: \(tryCountNumber)"
        coverImageView.isHidden = true
        inputTextField.isHidden = true
        resultButton.setTitle("결과 확인하기", for: .normal)
        resultButton.isEnabled = false
        collectionView.allowsSelection = true
    }
    
    func setNumbersForGame() {
        if let inputNumber = Int(inputTextField.text!) {
            numberList = Array(1...inputNumber)
            listEndNumber = inputNumber
            randomNumber = numberList.randomElement()!
        } else {
            print("failed to get input number!")
        }
    }
    
    func checkResult() {
        let isCorrect = (guessNumber == randomNumber)
        if isCorrect {
            titleLabel.text = "GOOD!"
            resultButton.setTitle("처음으로 돌아가기", for: .normal)
            collectionView.allowsSelection = false
            
            let index = numberList.firstIndex(of: guessNumber)!
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! NumberCollectionViewCell
            cell.highlightCell()
            
        } else {
            if guessNumber > randomNumber {
                titleLabel.text = "DOWN"
                listEndNumber = guessNumber

            } else if guessNumber < randomNumber {
                titleLabel.text = "UP"
                listStartNumber = guessNumber
            }
            numberList = Array(listStartNumber...listEndNumber)
            collectionView.reloadData()
            resultButton.isEnabled = false
        }
    }
}

// MARK: - TextField, Button Action 설정
extension ViewController {
    
    @IBAction func inputTextFieldEditingDidEnd(_ sender: UITextField) {
        guard let inputText = sender.text else { return }
        
        if !inputText.isEmpty || !(inputText.count > 4) {
            resultButton.isEnabled = true
        } else {
            inputTextField.text = ""
            resultButton.isEnabled = false
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        
        if buttonTitle == "시작하기" {
            setInGameStatus()
            setNumbersForGame()
            collectionView.reloadData()
            
        } else if buttonTitle == "결과 확인하기" {
            tryCountNumber += 1
            tryCountLabel.text = "시도 횟수: \(tryCountNumber)"

            checkResult()
            
        } else if buttonTitle == "처음으로 돌아가기" {
            setStandbyStatus()
        }
    }
}

// MARK: - Collection View 설정
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    static func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let xib = UINib(nibName: NumberCollectionViewCell.identifier, bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: NumberCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .banana
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = ViewController.collectionViewLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guessNumber = numberList[indexPath.item]
        resultButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.identifier, for: indexPath) as! NumberCollectionViewCell
        
        cell.configureData(numberList[indexPath.item])
        return cell
    }

}

