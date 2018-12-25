//
//  Constants.swift
//  cards
//
//  Created by Gaurang Lathiya on 25/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class Constants: NSObject {

    //application constant
    static let kApplicationName         =   "CARDS"
    
    static let SCREEN_SIZE: CGRect      =   UIScreen.main.bounds
    
    // WebService constants
    static let kStatus                  =   "status"
    static let kMessage                 =   "message"
    static let kResponse                =   "response"
    
    //AlertTitle Constants
    static let kAlertTypeOK             =   "OK"
    static let kAlertTypeCancel         =   "Cancel"
    static let kAlertTypeYES            =   "YES"
    static let kAlertTypeNO             =   "NO"
    
    // Internet connection
    static let kNoInterNetConnection    =   "No Internet Connection."
    
    // Error
    static let kErrorWebService         =   "Please try again."
    static let kErrorWSNoData           =   "No data found."
}
