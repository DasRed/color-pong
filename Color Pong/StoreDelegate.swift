import Foundation

protocol StoreDelegate {
    
    // product was successful buyed
    func productWasBuyed(product: Store.Product)
}