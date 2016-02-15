//
//  ProviderServicesHandler.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/10/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class ProviderServicesHandler: NSObject {

}

// names of licenses

// names of services

// associate licenses to services

public func servicesPermittedByLicense(license:LicenseType) -> Array<ServiceCategoryType> {
    
    var array = Array<ServiceCategoryType>()
    
    if (license == LicenseType.BarberType) {
        // associated types for barber
    array.appendContentsOf([ServiceCategoryType.kHairType])
  
    }
    
    if (license == LicenseType.CosmetologyType) {
    array.appendContentsOf([ServiceCategoryType.kCosmeticType, ServiceCategoryType.kHairType])
    }
    
    if (license == LicenseType.EtheticianType) {
    array.appendContentsOf([ServiceCategoryType.kSpaType, ServiceCategoryType.kNailsType])
    }
    
    if (license == LicenseType.EyeLashExtensionsType) {
    array.appendContentsOf([ServiceCategoryType.kSpaType])
    }
    
    if (license == LicenseType.FitnessType) {
    array.appendContentsOf([ServiceCategoryType.kTrainingType])
    }
    
    if (license == LicenseType.ManicuristEsthecticianType) {
    array.appendContentsOf([ServiceCategoryType.kNailsType])
    array.appendContentsOf([ServiceCategoryType.kSpaType])
    }
    
    if (license == LicenseType.ManicuristType) {
    array.appendContentsOf([ServiceCategoryType.kNailsType])
    }
    
    if (license == LicenseType.MassageType) {
    array.appendContentsOf([ServiceCategoryType.kMassageType])
        
    }
    
    if (license == LicenseType.PersonalTrainerType) {
    array.appendContentsOf([ServiceCategoryType.kTrainingType])
    }
    
    if (license == LicenseType.SprayTansType) {
  //  array.appendContentsOf([ServiceCategoryType.])
        /*
            None is needed for spray tans type.

        */
    }
    
    if (license == LicenseType.YogaType) {
    array.appendContentsOf([ServiceCategoryType.kYogaType])
    }
    
    return array
}

public func servicesPermittedByLicenses(licenses:Array<LicenseType>) -> Array<ServiceCategoryType> {
    
    var array = Array<ServiceCategoryType>()
    
    for license in licenses {
        array.appendContentsOf(servicesPermittedByLicense(license))
    }
    
    return array
}

public func licensesRequiredForService(service:ServiceCategoryType) -> Array<LicenseType> {
    
    var array = Array<LicenseType>()
    
    if (service == ServiceCategoryType.kCosmeticType) {
        array.append(LicenseType.CosmetologyType)
    }
    
    if (service == ServiceCategoryType.kHairType) {
        array.append(LicenseType.CosmetologyType)
    }
    
    return array
}