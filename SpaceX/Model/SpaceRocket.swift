//
//  SpaceRocket.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 20.07.2022.
//

struct StarRocket: Codable {
    var height: Height
    //var diameter: Diameter
    //var mass: Mass
    //var payload_weight: PayloadWeight
    //var first_stage: FirstStage
}

struct Height: Codable {
    let meters: Double
    let feet: Double
}

struct Diameter: Codable {
    let meters: Double
    let feet: Double
}

struct Mass: Codable {
    let kg: Int
    let lb: Int
}

struct PayloadWeight: Codable {
    let id: String
    let name: String
    let kg: Int
    let lb: Int
}

struct FirstStage: Codable {
    let engines: Int
    let fuel_amount_tons: Double
    let burn_time_sec: Int
}
