//
//  ViewController.swift
//  UpDownGame
//
//  Created by Kyuhee hong on 1/9/25.
//

import UIKit

class ViewController: UIViewController {

    var isStarted: Bool = false
    var numberList: [Int] = []
    var randomNumber: Int = 0
    var standardNumber: Int = 0
    var guessNumber: Int = 0
    var tryCountNumber: Int = 0

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tryCountLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var resultButton: UIButton!
    
    static let sectionInset: CGFloat = 8
    static let cellSpacing: CGFloat = 8
    static let itemInRow: CGFloat = 5
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
    }

    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        print(#function)
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
        view.backgroundColor = .background

        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 40, weight: .black)
        titleLabel.numberOfLines = 1
        titleLabel.frame.size = titleLabel.intrinsicContentSize
        
        tryCountLabel.textAlignment = .center
        tryCountLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        tryCountLabel.numberOfLines = 1
        tryCountLabel.frame.size = titleLabel.intrinsicContentSize
        tryCountLabel.contentMode = .top

        coverImageView.backgroundColor = .background
        coverImageView.image = UIImage(named: "updown")
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.isUserInteractionEnabled = true
        
        inputTextField.borderStyle = .line
        inputTextField.backgroundColor = .white
        inputTextField.keyboardType = .numberPad
        inputTextField.isHidden = false
        
        resultButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.setTitleColor(.lightGray, for: .disabled)

        setViewLinkedWithStatus()
    }
    
    func setViewLinkedWithStatus() {
        titleLabel.text = "UP DOWN"
        tryCountLabel.textColor = isStarted ?  .black : .gray
        tryCountLabel.text = isStarted ? "시도 횟수: \(tryCountNumber)" : "GAME"
        coverImageView.isHidden = isStarted
        resultButton.setTitle(isStarted ? "결과 확인하기" : "시작하기", for: .normal)
        resultButton.isEnabled = !((inputTextField.text?.isEmpty) != nil)
        resultButton.backgroundColor = resultButton.isEnabled ? .black : .gray
    }
    /* [고민되는 부분]
     상태값에 따라 달라지는 View 요소들을 모아서 한번에 갱신할 수 있게 해봤는데, 요소별로 불필요한 것들도 있었다.
     버튼 텍스트 같은 경우에는 바뀌기 전에 항상 트리거가 있어서 적절하게 바꿔줄 수 있는 타이밍이 있었다.
     무리하게 삼항연산자 사용하지 않아도 될 것 같기도 하고... 스유의 스테이트 바인딩이 그리워지는 저녁이다..
     */
    
}

// MARK: - TextField, Button Action 설정
extension ViewController {
    
    @IBAction func inputTextFieldEditingDidEnd(_ sender: UITextField) {
        guard let inputText = sender.text else { return }
        
        if !inputText.isEmpty || !(inputText.count > 4) {
            resultButton.isEnabled = true
        } else {
            resultButton.isEnabled = false
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        print(#function)
        let buttonTitle = sender.titleLabel?.text
        
        if buttonTitle == "시작하기" { // 시작하기 버튼
            print("numberList \(numberList)")
            if let inputNumber = inputTextField.text {
                standardNumber = Int(inputNumber) ?? 0
                print("selectedNumber \(standardNumber)")
            } else {
                print("failed to get input number!")
            }
            print("numberList \(numberList)")
            
            isStarted = true
            inputTextField.isHidden = true
            setViewLinkedWithStatus()
            
            collectionView.reloadData()
            
        } else if buttonTitle == "결과 확인하기" {
            
            // 0. 시도 횟수를 카운트
            tryCountNumber += 1

            // 1. guessNumber 와 randomNumber 를 비교
            let isCorrect = (guessNumber == randomNumber)
            
            if isCorrect {
                // 2-1. 정답이면 Good을 띄우기
                titleLabel.text = "GOOD!"
                //      버튼을 처음으로 돌아가기로 바꾸기
                resultButton.titleLabel?.text = "처음으로 돌아가기"
                //      컬렉션뷰 버튼 선택 가능하지 않도록 하기
                collectionView.allowsSelection = false
            } else {
                if guessNumber > randomNumber {
                    titleLabel.text = "DOWN"
                } else if guessNumber < randomNumber {
                    titleLabel.text = "UP"
                }
                standardNumber = guessNumber
                collectionView.reloadData()
            }
            
            
            // 2-2. 오답일 경우
            //      guessNumber 가 randomNumber 보다 작으면 UP 크면 DOWN 을 띄우기
            //      선택한 숫자를 토대로 컬렉션을 다시 그리기
            //      선택한 내용들 다 deselet 하기 -> 버튼이 다시 disabled 됨 -> reload 하면 자동으로 되려나
            
        } else {
            isStarted = false
            resultButton.isEnabled = false
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
        
        collectionView.backgroundColor = .background
        collectionView.allowsMultipleSelection = false
        collectionView.collectionViewLayout = ViewController.collectionViewLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.identifier, for: indexPath) as! NumberCollectionViewCell

        // 숫자버튼을 클릭하면
        // 1. 색상을 바꿔주고
        cell.circleView.backgroundColor = .black
        cell.numberLabel.textColor = .white
        
        // 2. guessNumber 를 할당하고
        guessNumber = indexPath.item+1
        
        // 3. 결과버튼을 활성화하기
        resultButton.isEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.identifier, for: indexPath) as! NumberCollectionViewCell
        
        cell.configureData(indexPath.item)
        print(#function, indexPath.item)
        return cell
    }

}

