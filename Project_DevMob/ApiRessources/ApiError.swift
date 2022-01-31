//
//  ApiError.swift
//  Project_DevMob
//
//  Created by goldorak on 31/01/2022.
//
import Foundation

// liste des erreurs possibles liées à l'API
enum ApiError: Error {
    case httpError(Error)
    case apiError(String, String)
    case parseError(Error, String)
}
