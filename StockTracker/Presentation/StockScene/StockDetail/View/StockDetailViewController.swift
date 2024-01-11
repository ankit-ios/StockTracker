//
//  StockDetailViewController.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

final class StockDetailViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    var stockDetail: StockDetail?
    private var viewModel: StockDetailViewModel!
    @IBOutlet private weak var tableView: UITableView!
    
    static func create(with viewModel: StockDetailViewModel) -> StockDetailViewController {
        let view = StockDetailViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchStockDetail()
        setupTableView()
        bind(to: viewModel)
    }
    
    private func setupTableView() {
        let cellIdentifiers = [StockDetailCell.reuseIdentifier, StockLogoCell.reuseIdentifier, StockReadMoreCell.reuseIdentifier]
        cellIdentifiers.forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: $0)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // To hide empty cells
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.allowsSelection = false
    }
    
    private func bind(to viewModel: StockDetailViewModel) {
        self.title = viewModel.screenTitle
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoadingView($0) }
        viewModel.stockDetail.observe(on: self) { [weak self] _ in
            self?.updateItems()
        }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    private func updateLoadingView(_ aFlag: Bool) {
        aFlag ? LoadingView.show() : LoadingView.hide()
    }
    
    private func updateItems() {
        DispatchQueue.main.async {
            self.stockDetail = self.viewModel.stockDetail.value
            self.tableView.reloadData()
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        DispatchQueue.main.async {
            self.showAlert(title: self.viewModel.errorTitle, message: error)
        }
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension StockDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataSource[indexPath.section][indexPath.row]
        
        switch data.cellType {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockDetailCell.reuseIdentifier, for: indexPath) as? StockDetailCell else {
                return UITableViewCell()
            }
            cell.configure(title: data.title, value: data.value)
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockLogoCell.reuseIdentifier, for: indexPath) as? StockLogoCell else {
                return UITableViewCell()
            }
            cell.configure(with: data.title, logoUrl: data.value)
            return cell
        case .readMore:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockReadMoreCell.reuseIdentifier, for: indexPath) as? StockReadMoreCell else {
                return UITableViewCell()
            }
            cell.configure(title: data.title, value: data.value)
            
            cell.readMoreTapped = { [weak self] in
                // Handle "Read more" button tapped
                // You can toggle between expanded and collapsed states
                self?.tableView.beginUpdates()
                cell.isExpanded.toggle()
                self?.tableView.endUpdates()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = viewModel.dataSource[indexPath.section][indexPath.row]
        
        switch data.cellType {
        case .text:
            let prototypeCell = tableView.dequeueReusableCell(withIdentifier: StockDetailCell.reuseIdentifier) as! StockDetailCell
            prototypeCell.configure(title: data.title, value: data.value)
            return prototypeCell.heightForCell(width: tableView.bounds.width * 0.4)
        case .image:
            return 170.0
        case .readMore:
            return UITableView.automaticDimension
        }
    }
}

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let session = URLSession.shared
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // If not cached, download the image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image download error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                // Cache the downloaded image
                self.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                completion(downloadedImage)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    // Optional: Clear the image cache
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
