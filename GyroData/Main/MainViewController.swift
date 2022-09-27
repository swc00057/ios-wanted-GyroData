//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    var datasource = [GyroModel]()
    let manager = CoreDataManager.shared
    let FileManager = MeasureFileManager.shared
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
        addNaviBar()
//        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
        //        manager.fetch()
//        datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))

        //                manager.fetchTen(offset: datasource.count)
                loadData()
//        tableView.reloadData()
    }
    private func setupView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
   
    
    //네비바 추가
    private func addNaviBar() {
        title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정",style: .plain,target: self, action: #selector(measureButton))
    }
    
    //측정버튼액션
    @objc func measureButton(_ sender: UIBarButtonItem) {
        print("측정버튼")
        let MeasureView = MeasureViewController()
        self.navigationController?.pushViewController(MeasureView, animated: true)
        tableView.reloadData()
        //        loadData()
        //
    }
    //실행시 기존데이터 로드
    private func loadData() {
//                manager.fetch()
//        manager.fetchTen(offset: 0)
//        datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
//        print("데이터소스 카운트\(datasource.count)")
        datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
//        print("데이터소스 카운트\(datasource.count)")
        tableView.reloadData()
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //테이블셀이 10개일때 데이터를 10개불러오는곳??
//        let fetchData = manager.fetchTen(count: count)
//        print("111indexPath: \(indexPath.row) datasource.count: \(datasource.count)")
        guard indexPath.row == manager.fetchTen1(offset: datasource.count).count - 1 else {return}
     
//            loadData()
            //        count += fetchData.count
            datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
        tableView.reloadData()
        print("2222indexPath: \(indexPath.row) datasource.count: \(datasource.count)")
//            datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
            //        datasource.append(contentsOf: manager.fetchTen1(offset: datasource.count))
            //        print("\(fetchData.count)🐤")
//            tableView.reloadData()
     }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return datasource.count
//           manager.fetchTen(count: count)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as? CustomTableViewCell else { return UITableViewCell() }
            cell.bind1(model: datasource[indexPath.row])
            //manager.fetchTen(count: count)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
        //SwipeAction
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let playAction = UIContextualAction(style: .normal, title:"Play"){ (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                print("paly 클릭 됨")
                let vc = ReplayViewController()
                let data = self.datasource[indexPath.row]
                guard let date = data.measureDate else { return }
                let change = Measure(id: data.id ?? "0",
                                     title: data.title ?? "타입안변함",
                                     second: data.second ,
                                     date: date,
                                     pageType: .play)
                vc.measureData = change
                self.navigationController?.pushViewController(vc, animated: true)
                
                //self.datasource[indexPath.row]
                //print(self.manager.count()!, self.datasource[indexPath.row].id!)
                success(true)
            }
            // 코어데이터 제거
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                print("delete 클릭 됨")
//                self.manager.delete(object: self.datasource[indexPath.row])
                self.manager.delete(object: self.datasource.remove(at: [indexPath.row].count))
                // self.manager.deleteAll()
//                self.manager.delete(object: self.datasource[indexPath.row])
                tableView.reloadData()
                success(true)
            }
            playAction.backgroundColor = .systemGreen
            deleteAction.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
        }
    }

//테이블뷰셀 선택시 3번째뷰컨트롤러뷰타입으로
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ReplayViewController()
        let data = datasource[indexPath.row]
        guard let date = data.measureDate else { return }
        let change = Measure(id: data.id ?? "0",
                             title: data.title ?? "타입안변함",
                             second: data.second ,
                             date: date,
                             pageType: .view)
        vc.measureData = change
//        let measure = Measure(
        self.navigationController?.pushViewController(vc, animated: true)
        print(datasource[indexPath.row].id!)
    }
}






