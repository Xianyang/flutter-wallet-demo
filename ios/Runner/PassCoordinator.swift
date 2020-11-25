//
//  PassCoordinator.swift
//  Runner
//
//  Created by XIANYANG LUO on 11/25/20.
//

import Foundation
import UIKit
import PassKit

final class PassCoordinator: BaseCoordinator {
    weak var navigationController: UINavigationController?
    weak var delegate: PassToAppCoordinatorDelegate?
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
    override func start() {
        super.start()
    }
    
    func retrievePass(url: String) {
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data as NSData? else {
                return
            }
            
            print("successfully retrieved pass data from server")
            
            DispatchQueue.main.async {
                self.openPassWithData(passData: data)
            }
        }
        
        task.resume()
    }
    
    func openPassWithData(passData : NSData) {
        do {
            let newpass = try PKPass.init(data: passData as Data)
            let addController =  PKAddPassesViewController(pass: newpass)
            addController?.delegate = navigationController as? PKAddPassesViewControllerDelegate
            navigationController?.present(addController!, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "PassKit not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    break
                }}))
            navigationController?.present(alert, animated: true, completion: nil)

            print(error)
        }
    }
    
    //Function to open wallet view in your app.
    func loadWalletView() {
        if !PKPassLibrary.isPassLibraryAvailable() {
            let alert = UIAlertController(title: "Error", message: "PassKit not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    break
                }}))
            navigationController?.present(alert, animated: true, completion: nil)
        }
        let resourcePath : String? = Bundle.main.resourcePath

        do {
            let passFiles : NSArray = try FileManager.default.contentsOfDirectory(atPath: resourcePath!) as NSArray
            for  passFile in passFiles {

                let passFileString = passFile as! String
                if passFileString.hasSuffix(".pkpass") {
                    openPassWithName(passName: passFileString)
                }
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    func openPassWithName(passName : String) {
        print(passName)

        let passFile = Bundle.main.resourcePath?.appending("/\(passName)")
        let passData = NSData(contentsOfFile: passFile!)

        do {
            let newpass = try PKPass.init(data: passData! as Data)
            let addController =  PKAddPassesViewController(pass: newpass)
            addController?.delegate = navigationController as? PKAddPassesViewControllerDelegate
            navigationController?.present(addController!, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "PassKit not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    break
                }}))
            navigationController?.present(alert, animated: true, completion: nil)

            print(error)
        }
    }
    
    
}
