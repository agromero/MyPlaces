//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let manager: ManagerPlaces = ManagerPlaces.shared
                
        let pl1 = Place(name: "Title Place1", description: "Esta es la descipción del Place 1, todavía falta contenido, pero por ahora es suficiente con este texto de prueba para comprobar que se visualiza correctamente por pantalla", image_in: nil)
        let pl2 = Place(name: "Title Place2", description: "Aqui se tiene que pone la descripción del Place 2, ya que es un lugar increíble que nadie debe perderse, os lo recomiendo 100% si tenéis la oportunidad de visitarlo", image_in: nil)
        let pl3 = Place(name: "Title Place3", description: "El Place 3 es sin duda uno de los mejores lugares que podéis encontrar en esta app, aunque de momento solamente está disponible este texto de prueba.", image_in: nil)
        let pl4 = Place(name: "Title Place4", description: "Aqui está el Place 4, con su texto de prueba y unas pocas palabras para rellenar este espacio provisional donde irá la descripción real del sitio.", image_in: nil)
        manager.append(pl1)
        manager.append(pl2)
        manager.append(pl3)
        manager.append(pl4)
                
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

