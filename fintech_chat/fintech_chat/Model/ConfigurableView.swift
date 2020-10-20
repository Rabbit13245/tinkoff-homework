import Foundation

protocol ConfigurableView{
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
