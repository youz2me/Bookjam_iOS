//
//  MainPageVC.swift
//  Bookjam
//
//  Created by 장준모 on 2023/07/26.
//

// MARK: - 메인 탭바에서 홈을 눌렀을 때 나오는 메인 페이지 화면

import UIKit
import SwiftUI

import SnapKit
import Then


class MainPageVC: UIViewController {

    // MARK: Variables
    
    //api 모델 변수 - 이 변수에 api 호출 결과를 저장하여 뷰 업데이트 등에 사용
    var bookStoreList: [GetPlaceResponseModel]?
    
    var searchBarButton: UIButton = UIButton().then {
        $0.setTitle("  상호명 또는 주소 검색", for: .normal)
        $0.setTitleColor(gray06, for: .normal)
        $0.titleLabel?.font = paragraph02
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = main03
        $0.layer.borderColor = main02?.cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(didSearchBarButtonTapped), for: .touchUpInside)
    }
    
    var independentBookstoreButton: UIButton = UIButton().then {
        $0.setTitle("독립서점", for: .normal)
        $0.tintColor = main03
        $0.titleLabel?.font = paragraph02
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .regular, scale: .default)
        let image = UIImage(systemName: "book.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 20
        configuration.imagePlacement = .top
        
        $0.configuration = configuration
    }
    
    var bookPlayGroundButton: UIButton = UIButton().then {
        $0.setTitle("책 놀이터", for: .normal)
        $0.tintColor = gray05
        $0.titleLabel?.font = paragraph02
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .regular, scale: .default)
        let image = UIImage(systemName: "cup.and.saucer.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 20
        configuration.imagePlacement = .top
        
        $0.configuration = configuration
    }
    
    var libraryButton: UIButton = UIButton().then {
        $0.setTitle("도서관", for: .normal)
        $0.tintColor = gray05
        $0.titleLabel?.font = paragraph02
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 30, weight: .regular, scale: .default)
        let image = UIImage(systemName: "books.vertical.fill", withConfiguration: config)
        $0.setImage(image, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 20
        configuration.imagePlacement = .top
        
        $0.configuration = configuration
    }
    
    var sortView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var lineView: UIView = UIView().then {
        $0.backgroundColor = gray04
    }
    
    var sortButton: UIButton = UIButton()
    
//    var sortButton: UIButton = UIButton().then {
//        $0.setTitle("거리순   ", for: .normal)
//        $0.setTitleColor(gray05, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//
//        let config = UIImage.SymbolConfiguration(
//            pointSize: 17, weight: .light, scale: .small)
//        $0.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
//        $0.tintColor = .black
//        $0.semanticContentAttribute = .forceRightToLeft
//
//
//        // TODO: 정렬 API 나오면 연결
//        $0.menu = UIMenu(children: [
//            UIAction(title: "거리순   ", state: .on, handler: {
//                _ in
//            }),
//            UIAction(title: "리뷰순   ", handler: { _ in print("리뷰순")}),
//            UIAction(title: "평점순   ", handler: { _ in print("평점순")}),
//        ])
//        /// 터치하면 바로 메뉴 나오도록 설정
//        $0.showsMenuAsPrimaryAction = true
//        /// 체크 표시 하나만 할 수 있도록 설정
//        $0.changesSelectionAsPrimaryAction = true
//    }
    
    var infoButton: UIButton = UIButton().then {
        $0.setImage(UIImage(systemName: "info.circle"), for: .normal)
        $0.tintColor = gray05
    }
    
    var tableView: UITableView = UITableView().then {
        $0.register(MainPageBookStoreTableViewCell.self, forCellReuseIdentifier: "bookStoreCell")
    }
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpLayout()
        setUpConstraint()
        setUpDelegate()
        
        setUpSortButtons()
        getIndependantBookStorePlaces(category: 0, sortBy: "distance", lat: 37.270225, long: 127.048789)  //임시 테스트
    }
    
    // MARK: View
    
    func setUpView() {
        view.backgroundColor = .white
        tableView.separatorStyle = .singleLine
    }

    // MARK: Layout
    
    // TODO: 데모데이 이후 주석 풀기
    func setUpLayout(){
        [
            searchBarButton,
            // independentBookstoreButton,
            // bookPlayGroundButton,
            // libraryButton,
            tableView,
            sortView
        ].forEach {
            view.addSubview($0)
        }
        sortView.addSubview(lineView)
        sortView.addSubview(sortButton)
        sortView.addSubview(infoButton)
    }
    
    // MARK: Constraints

    // TODO: 데모데이 이후 버튼 주석 풀기
    func setUpConstraint(){
        searchBarButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
        }
        
//        independentBookstoreButton.snp.makeConstraints {
//            $0.top.equalTo(searchBarButton.snp.bottom).offset(25)
//            $0.leading.equalToSuperview().offset(30)
//        }
//
//        bookPlayGroundButton.snp.makeConstraints {
//            $0.centerY.equalTo(independentBookstoreButton)
//            $0.centerX.equalToSuperview()
//        }
//
//        libraryButton.snp.makeConstraints {
//            $0.centerY.equalTo(independentBookstoreButton)
//            $0.trailing.equalToSuperview().offset(-30)
//        }
        
        sortView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(30)
        }
        
        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(sortButton)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }//end of setUpConstraint
    
    
    // MARK: Delegate
    
    func setUpDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: Function
    
    @objc func didSearchBarButtonTapped() {
        navigationController?.pushViewController(SearchPageVC(), animated: true)
    }
    
    //
    func getIndependantBookStorePlaces(category: Int, sortBy: String?, lat: Float? = nil, long: Float? = nil){
        
        var requestParameter: getPlaceRequestModel
            
            if let latitude = lat, let longitude = long {
                requestParameter = getPlaceRequestModel(category: category, sortBy: sortBy, lat: latitude, lon: longitude)
            } else {
                requestParameter = getPlaceRequestModel(category: category, sortBy: sortBy)
            }
        
        APIManager.shared.getData(
            urlEndpointString: Constant.getPlaces,
            responseDataType: APIModel<[GetPlaceResponseModel]>?.self,
            requestDataType: getPlaceRequestModel.self,
            parameter: requestParameter,
            completionHandler: { [self]
                response in
                    print(response)
                self.bookStoreList = response?.result
                self.tableView.reloadData()
            })
    }//end of getIndependantBookStorePlaces
    
    //  정렬 버튼 셋업 함수
    func setUpSortButtons() {
            sortButton.setTitle("거리순", for: .normal)
            sortButton.setTitleColor(gray05, for: .normal)
            sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            let config = UIImage.SymbolConfiguration(
                pointSize: 17, weight: .light, scale: .small)
            sortButton.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
            sortButton.tintColor = .black
            sortButton.semanticContentAttribute = .forceRightToLeft
            
            sortButton.menu = UIMenu(children: [
                UIAction(title: "거리순", state: .on, handler: { _ in
                    self.getIndependantBookStorePlaces(category: 0, sortBy: "distance", lat: 37.270225, long: 127.048789)
                }),
                UIAction(title: "리뷰순", handler: { _ in
                    print("리뷰순")
                    self.getIndependantBookStorePlaces(category: 0, sortBy: "review")
                }),
                UIAction(title: "평점순", handler: { _ in
                    print("평점순")
                    self.getIndependantBookStorePlaces(category: 0, sortBy: "rating")
                }),
            ])
            
            sortButton.showsMenuAsPrimaryAction = true
            sortButton.changesSelectionAsPrimaryAction = true
            
        }
    
    
}//end of MainPageVC


// MARK: Extension

/// 거리순 밑으로 보여질 tableView 구현을 위한 Delegate, DataSource extension
extension MainPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = bookStoreList?.count{
            return count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookStoreCell", for: indexPath) as! MainPageBookStoreTableViewCell
        
        if let bookStoreList = bookStoreList {
            let book = bookStoreList[indexPath.row]
            cell.bookstoreLabel.text = book.name
            cell.locationLabel.text = book.address?.road
            if let rating = bookStoreList[indexPath.row].rating {
                cell.starLabel.text = String(rating)
            }
            
            if let reviewCount = bookStoreList[indexPath.row].reviewCount {
                cell.reviewCountLabel.text = "리뷰 " + String(reviewCount) + "개"
            }
            if let imageUrls = bookStoreList[indexPath.row].images {    //이미지 url을 이미지로
                cell.images = imageUrls
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//셀 클릭 시 해당 placeId api 불러오고 디테일뷰로 전환
        let detailPage = BookstoreDetailPageVC()
        
        let selectedPlaceId = bookStoreList![indexPath.row].placeId!
        
        APIManager.shared.getData(
            urlEndpointString: Constant.getPlaceId(placeId: selectedPlaceId),
            responseDataType: APIModel<PlaceIdResponseModel>?.self,
            requestDataType: PlaceIdRequestModel.self,
            parameter: nil,
            completionHandler: { [self]
                response in
                    print(response)
                detailPage.bookStoreDetail = response?.result ?? nil
                navigationController?.pushViewController(detailPage, animated: true)
            })
        
    }
}

struct MainPageVC_Preview: PreviewProvider {
    static var previews: some View {
        MainPageVC().toPreview()
            //.edgesIgnoringSafeArea(.all)
    }
}
