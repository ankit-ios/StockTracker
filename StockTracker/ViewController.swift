//
//  ViewController.swift
//  StockTracker
//
//  Created by Ankit Sharma on 04/01/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var stockUseCase: StockUseCaseProtocol!
    @IBOutlet weak var tableView: UITableView!

    var stocks: [Stock] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Stock List"
        
        // Initialize dependencies (you might be using dependency injection or some other mechanism)
        let apiClient = APIClient()
        stockUseCase = StockUseCase(apiClient: apiClient)
        
        let nib = UINib(nibName: "StockListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StockListCell")

        
        // Fetch stocks and update the UI
        fetchDataAndUpdateUI()
    }
    
    func fetchDataAndUpdateUI() {
           // Assume 'stockUseCase' is an instance of your StockUseCase
           stockUseCase.fetchStockList { result in
               switch result {
               case .success(let data):
                   do {
                       let decodedStocks = try JSONDecoder().decode([Stock].self, from: data)
                       self.stocks = decodedStocks
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                   } catch {
                       print("Decoding error:", error)
                   }
               case .failure(let error):
                   print("Error:", error)
               }
           }
       }

       // MARK: - UITableViewDataSource

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return stocks.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockListCell", for: indexPath) as! StockListCell
        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
        return cell
    }
    
    // MARK: - UITableViewDelegate

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Handle selection if needed
           let selectedStock = stocks[indexPath.row]
           
           let vc = StockDetailViewController.instance
           vc.stock = selectedStock
           self.navigationController?.pushViewController(vc, animated: true)
           
           
           print("Selected Stock: \(selectedStock)")
       }
}

protocol APIClientProtocol {
    func fetchData(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void)
}

enum Endpoint {
    case stockList
    case stockDetails(symbol: String)
    
    var path: String {
        switch self {
        case .stockList:
            return "search?query=A&currency=USD&limit=30&apikey=aTu0U63IQ3Yv2jgv2gKyNaDqTHAKYAkP"
        case .stockDetails(let symbol):
            return "profile/\(symbol)?apikey=aTu0U63IQ3Yv2jgv2gKyNaDqTHAKYAkP"
        }
    }
    
    var url: URL {
        return URL(string: "https://financialmodelingprep.com/api/v3/\(path)")!
    }
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

class APIClient: APIClientProtocol {
    func fetchData(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) {
        let url = endpoint.url
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}


protocol StockUseCaseProtocol {
    func fetchStockList(completion: @escaping (Result<Data, APIError>) -> Void)
    // Additional methods for other use cases
}

class StockUseCase: StockUseCaseProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchStockList(completion: @escaping (Result<Data, APIError>) -> Void) {
        let endpoint = Endpoint.stockList
        apiClient.fetchData(from: endpoint, completion: completion)
    }
    
    // Additional methods for other use cases
}


struct Stock: Decodable {
    let symbol: String
    let name: String
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
}

struct StockDetail: Decodable {
    let symbol: String
    
    let image :String? //": "https://financialmodelingprep.com/image-stock/AXL.png",

    
    let companyName: String
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
    let price: Double?

    
    let description: String?
    
    let industry :String? //": "Auto Parts",
    let ceo :String? //": "Mr. David Charles Dauch",
    let sector :String? //": "Consumer Cyclical",
    let country :String? //": "US",
    let fullTimeEmployees :String? //": "19000",
    let phone :String? //": "313 758 2000",
    let address :String? //": "One Dauch Drive",
    let city :String? //": "Detroit",
    let state :String? //": "MI",
    let zip :String? //": "48211-1198",
    let website :String? //": "https://www.aam.com",
}
