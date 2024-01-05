//
//  StockDetailViewController.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

enum StockDetailCellType {
    case text
    case image
    case readMore
}

struct StockDetailDataSource {
    let id = UUID().uuidString
    let title: String
    let value: String?
    let cellType: StockDetailCellType
    
    init(title: String, value: String?, cellType: StockDetailCellType = .text) {
        self.title = title
        self.value = value
        self.cellType = cellType
    }
}


class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var stock: Stock?
    var stockDetail: StockDetail?
    private var stockDetailUseCase: StockDetailUseCaseProtocol!
    @IBOutlet weak var tableView: UITableView!
    
    
    static var instance: StockDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "StockDetailViewController") as! StockDetailViewController
    }
    
    private let sections: [String] = ["General Information", "Company Details", "Contact Information"]
    
    private var data: [[StockDetailDataSource]] { [
        // General Information Section
        [
            .init(title: "Company Name", value: stockDetail?.companyName),
            .init(title: "Company Logo", value: stockDetail?.image, cellType: .image),
            .init(title: "Currency", value: stockDetail?.currency),
            .init(title: "Stock Exchange", value: stockDetail?.stockExchange),
            .init(title: "Exchange Short Name", value: stockDetail?.exchangeShortName),
            .init(title: "Price", value: stockDetail?.price.map { String($0) })
        ],
        // Company Details Section
        [
            .init(title: "Description", value: stockDetail?.description, cellType: .readMore),
            .init(title: "Industry", value: stockDetail?.industry),
            .init(title: "CEO", value: stockDetail?.ceo),
            .init(title: "Sector", value: stockDetail?.sector),
            .init(title: "Country", value: stockDetail?.country),
            .init(title: "Full-Time Employees", value: stockDetail?.fullTimeEmployees),
            .init(title: "Website", value: stockDetail?.website)
        ],
        // Contact Information Section
        [
            .init(title: "Phone", value: stockDetail?.phone),
            .init(title: "Address", value: stockDetail?.address),
            .init(title: "City", value: stockDetail?.city),
            .init(title: "State", value: stockDetail?.state),
            .init(title: "Zip", value: stockDetail?.zip)
        ]
    ] }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>>>>>")
        
        print(stock)
        print("<<<<<<<<<<")
        self.title = stock?.symbol
        
        let apiClient = APIClient()
        stockDetailUseCase = StockDetailUseCase(apiClient: apiClient)
        
        ["StockDetailCell", "StockLogoCell", "StockReadMoreCell"].forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: $0)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // To hide empty cells
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.allowsSelection = false
        
        fetchDataAndUpdateUI()
        
    }
    
    
    func fetchDataAndUpdateUI() {
        // Assume 'stockUseCase' is an instance of your StockUseCase
        stockDetailUseCase.fetchStockDetail(symbol: stock?.symbol ?? "") { result in
            switch result {
            case .success(let data):
                do {
                    let decodedStockDetail = try JSONDecoder().decode([StockDetail].self, from: data)
                    DispatchQueue.main.async {
                        self.stockDetail = decodedStockDetail.first
                        self.tableView.reloadData()
                    }
                    print(decodedStockDetail)
                } catch {
                    print("Decoding error:", error)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = data[indexPath.section][indexPath.row]
        
        switch data.cellType {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockDetailCell", for: indexPath) as? StockDetailCell else {
                return UITableViewCell()
            }
            cell.configure(title: data.title, value: data.value)
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockLogoCell", for: indexPath) as? StockLogoCell else {
                return UITableViewCell()
            }
            cell.configure(with: data.title, logoUrl: data.value)
            return cell
        case .readMore:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockReadMoreCell", for: indexPath) as? StockReadMoreCell else {
                return UITableViewCell()
            }
            cell.configure(title: data.title, value: data.value)
            
            cell.readMoreTapped = { [weak self] in
                // Handle "Read more" button tapped
                // You can toggle between expanded and collapsed states
                self?.tableView.beginUpdates()
                cell.valueLabel.numberOfLines = cell.valueLabel.numberOfLines == 3 ? 0 : 3
                cell.updateButtonTitle()
                self?.tableView.endUpdates()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = data[indexPath.section][indexPath.row]
        
        switch data.cellType {
        case .text:
            let prototypeCell = tableView.dequeueReusableCell(withIdentifier: "StockDetailCell") as! StockDetailCell
            prototypeCell.configure(title: data.title, value: data.value)
            return prototypeCell.heightForCell(width: tableView.bounds.width * 0.4)
        case .image:
            return 170.0
        case .readMore:
            return UITableView.automaticDimension
        }
    }
}

protocol StockDetailUseCaseProtocol {
    func fetchStockDetail(symbol: String, completion: @escaping (Result<Data, APIError>) -> Void)
}

class StockDetailUseCase: StockDetailUseCaseProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchStockDetail(symbol: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        let endpoint = Endpoint.stockDetails(symbol: symbol)
        apiClient.fetchData(from: endpoint, completion: completion)
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
