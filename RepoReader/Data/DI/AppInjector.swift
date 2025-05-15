//
//  AppInjector.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Swinject

class AppInjector {

    fileprivate var appAssembler: Assembler!

    private init() {}

    static let shared = AppInjector()

    func initInjector() {
        appAssembler = Assembler([AppAssembly()])
    }

    func setTestAssembler (assemblies: [Assembly]) {
        appAssembler = Assembler(assemblies)
    }
}

// ***************************************************
// MARK: - Dependency Resolver methods
// ***************************************************

func appResolve<S>(serviceType: S.Type) -> S {
    AppInjector.shared.appAssembler.resolver.resolve(serviceType)!
}

@propertyWrapper
public struct AppInject<Component> {

    private var component: Component

    public init() {
        self.component = appResolve(serviceType: Component.self)
    }

    public var wrappedValue: Component {
        get { return component}
        mutating set { component = newValue }
    }
}

