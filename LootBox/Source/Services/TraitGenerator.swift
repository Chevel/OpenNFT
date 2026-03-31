//
//  TraitGenerator.swift
//  LootBox
//
//  Created by Matej on 23/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

class TraitGenerator {
    
    // MARK: - Init

    private init() {}
    
    // MARK: - Interface
    
    static func getRandomImageModel(for trait: TraitModel) -> ImageViewModel? {
        let allOdds = trait.imagesData.map { $0.odds }
        
        guard !allOdds.isEmpty else { return nil }

        let index = randomNumber(probabilities: allOdds)
        return trait.imagesData[safe: index]
    }

    // MARK: - Helper

    private static func randomNumber(probabilities: [Double]) -> Int {
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
}
