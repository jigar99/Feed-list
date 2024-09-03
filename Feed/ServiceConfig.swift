//
//  ServiceConfig.swift
//  Feed
//
//  Created by Jigar on 9/1/24.
//

import Foundation

enum BaseUrl : String {
    case dev = "https:\\xyz-.com"
    case prod = "https:\\xyzy-.com"
    case stage = "https:\\xyzyr-.com"
}


class ServiceConfig {
    
    static var shared = ServiceConfig()
    
    private var baseURls: String?
    
    func setupServiceCongfig() {
        
        
            #if Dev
             self.baseURls =  BaseUrl.dev.rawValue
            #elseif Prod
            self.baseURls =  BaseUrl.prod.rawValue
            #elseif Staging
            self.baseURls =  BaseUrl.stage.rawValue
            #endif
        
    }
}
