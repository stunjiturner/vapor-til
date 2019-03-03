//
//  CategoryTemplate.swift
//  App
//
//  Created by Mats Mollestad on 03/03/2019.
//

import HTMLKit
import Vapor

struct CategoryTemplate: ContextualTemplate {

    struct Context {
        let category: Category
        let base: BaseTemplate.Context
        var table: AcronymListTemplate.Context

        init(category: Category, acronyms: [Acronym], req: Request) throws {
            self.category = category
            self.table = .init(acronyms: acronyms)
            self.base = try .init(title: category.name, req: req)
        }
    }

    func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(content:
                h2.child(
                    variable(\.category.name)
                ),
                embed(
                    AcronymListTemplate(),
                    withPath: \.table
                )
            ),
            withPath: \Context.base)
    }
}
