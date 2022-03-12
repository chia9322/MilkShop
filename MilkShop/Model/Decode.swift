//
//  jsonDecode.swift
//  MilkShop
//
//  Created by Chia on 2022/02/01.
//

import Foundation

func loadJsonFile(_ filename: String) -> (Data){
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError()
    }
    do {
        data = try Data(contentsOf: file)
        return data
    } catch {
        fatalError()
    }
}

func decodeJsonData<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError()
    }
}



