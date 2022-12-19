//
//  AppDelegate.swift
//  MyPets
//
//  Created by Mac on 19/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let startDay = "startDay"
    static let endDay = "endDay"
    static let startTime = "startTime"
    static let endTime = "endTime"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Save data from config file...
        saveConfigData()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    func saveConfigData() {
        
        var json: Any?
        let jsonData = UIApplication.shared.readLocalJSONFile(forName: "config")
        if let aData = jsonData {
            json = try? JSONSerialization.jsonObject(with: aData)
        }
        
        guard let aData = json as? [String: Any] else { return }
        guard let aSettings = aData["settings"] as? [String: Any] else { return }
        guard let aStrWorkHours = aSettings["workHours"] as? String else { return }
        
        let arrData = aStrWorkHours.components(separatedBy: " ")
        guard arrData.count > 0 else { return }
        let arrDays = arrData.first?.components(separatedBy: "-")
        
        let aStartDay = getIntValueForDay(arrDays?.first ?? "")
        let aEndDay = getIntValueForDay(arrDays?.last ?? "")
        
        let aStartTime = arrData[1]
        let aEndTime = arrData.last ?? ""
        
        UserDefaults.standard.set(aStartDay, forKey: AppDelegate.startDay)
        UserDefaults.standard.set(aEndDay, forKey: AppDelegate.endDay)
        UserDefaults.standard.set(aStartTime, forKey: AppDelegate.startTime)
        UserDefaults.standard.set(aEndTime, forKey: AppDelegate.endTime)
        
    }
    
    func getIntValueForDay(_ day: String) -> Int {
        switch day {
        case "Su":
            return 1
        case "M":
            return 2
        case "Tu":
            return 3
        case "W":
            return 4
        case "Th":
            return 5
        case "F":
            return 6
        case"Sa":
            return 7
            
        default:
            return 0
        }

    }
    
    func checkCurrentTimeIsWorkingHours() {
    
        // Get the data of app settings and compare.
        let aToday = Date()
        let aStartDay = UserDefaults.standard.integer(forKey: AppDelegate.startDay)
        let aEndDay = UserDefaults.standard.integer(forKey: AppDelegate.endDay)
        
        let aStrStartTime = UserDefaults.standard.string(forKey: AppDelegate.startTime) ?? ""
        let aStrEndTime = UserDefaults.standard.string(forKey: AppDelegate.endTime) ?? ""
       
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: aToday)
        let dayOfWeek = components.weekday ?? 0
        
        if dayOfWeek >= aStartDay && dayOfWeek <= aEndDay {
            
            // Today falls in working day...
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let aStrToday = dateFormatter.string(from: aToday)
            
            guard let aStartTime = dateFormatter.date(from: aStrStartTime) else { return }
            guard let aEndTime = dateFormatter.date(from: aStrEndTime) else { return }
            let now = dateFormatter.date(from: aStrToday) ?? Date()
            
            // Check current time falls in working hours or not...
            if aStartTime.compare(now) == .orderedAscending && aEndTime.compare(now) == .orderedDescending {
                 
                // Current time is working hours so no need to show popup...
            } else {
                // Show Popup
                showPopup()
            }
        } else {
            
            // Show Popup
            showPopup()
        }
        
    }
    
    func showPopup() {
        let aTopVC = UIApplication.shared.topViewController()
        guard let aPopupVC = aTopVC?.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else { return }
        aTopVC?.addChild(aPopupVC)
        aTopVC?.view.addSubview(aPopupVC.view)
        aPopupVC.didMove(toParent: aTopVC)
    }
}

extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
