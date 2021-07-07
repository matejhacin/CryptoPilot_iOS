//
//  NotificationsPermissionViewModel.swift
//  Crypto Pilot
//
//  Created by Matej Hacin on 03/07/2021.
//

import Foundation

class NotificationsPermissionViewModel: ObservableObject {
    
    private let notificationsManager: NotificationsManager
    
    init(notificationsManager: NotificationsManager = NotificationsManager()) {
        self.notificationsManager = notificationsManager
    }
    
    func requestNotificationsPermission(finish: @escaping ((Bool) -> Void)) {
        notificationsManager.requestPermission(finish: finish)
    }
    
}
