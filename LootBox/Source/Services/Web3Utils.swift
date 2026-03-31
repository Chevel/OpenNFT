//
//  Web3Utils.swift
//  LootBox
//
//  Created by Matej on 24/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import JavaScriptCore

// https://docs.ethers.org/v5/getting-started/#installing
final class Web3Utils {
    
    // MARK: - Properties

    public static let shared = Web3Utils()
    private let jsContext = JSContext()!

    // MARK: - Init

    private init() {
        injectEtherJS(into: jsContext)
        injectCustomFunctions(into: jsContext)
    }

    // MARK: - Helper

//    private func injectEtherJS(into context: JSContext) {
//        guard
//            let jsSourcePath = Bundle.main.url(forResource: "ether", withExtension: "js"),
//            let jsSourceContents = try? String(contentsOf: jsSourcePath)
//        else {
//            fatalError("missing ether.js file")
//        }
//        context.evaluateScript(jsSourceContents)
//    }
    
    // https://github.com/ethers-io/ethers.js/tree/main/dist/ethers.min.js
    private func injectEtherJS(into context: JSContext) {
        let code =
        """
        <script src="https://cdn.ethers.io/lib/ethers-5.2.umd.min.js"
                type="application/javascript"></script>
        """
        context.evaluateScript(code)
    }

    private func injectCustomFunctions(into context: JSContext) {
        let code =
        """
        function isEthAddressValid(address) {
            return ethers.utils.isAddress("address");
        }
        """
        context.evaluateScript(code)
    }
    
    // MARK: - Validation

    public func isValidEtherAddress(address: String) -> Bool {
        guard let jsFunction = self.jsContext.objectForKeyedSubscript("isEthAddressValid") else {
            return false
        }
        let value = jsFunction.call(withArguments: ["\(address)"]).toBool()
        return value
    }
}
