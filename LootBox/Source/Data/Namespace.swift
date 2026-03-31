//
//  Namespace.swift
//  LootBox
//
//  Created by Matej on 21. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

typealias EmptyClosure = (() -> Void)
typealias ResultClosure = ((Result<Void, Error>) -> Void)
typealias LoginClosure = ((Result<User, Error>) -> Void)
