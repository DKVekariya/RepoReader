//
//  DependencyInjection.swift
//  RepoReader
//
//  Created by Divyesh Vekariya on 14/05/25.
//

import Foundation
import Alamofire
import Swinject
import SwiftData

public class AppAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.register(Session.self) { r in
            Session.init()
        }.inObjectScope(.container)

        container.register(APIClient<RepoApi>.self) { _ in
            APIClient<RepoApi>.init(session: appResolve(serviceType: Session.self))
        }.inObjectScope(.container)

        container.register(RepoRepository.self) { r in
            RepoRepositoryImpl.init(client: r.resolve(APIClient<RepoApi>.self)!)
        }.inObjectScope(.container)

        container.register(DatabaseManager.self) { _ in
            let context = try? ModelContext(.init(for: Repository.self, configurations: .init(isStoredInMemoryOnly: false)))
            return DatabaseManagerImpl.init(context: context)
        }.inObjectScope(.container)
    }
}
