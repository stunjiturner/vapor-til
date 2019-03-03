//
//  IndexTemplate.swift
//  App
//
//  Created by Mats Mollestad on 03/03/2019.
//

import HTMLKit
import Vapor

struct IndexTemplate: ContextualTemplate {

    struct Context {
        let base: BaseTemplate.Context
        let acronyms: AcronymListTemplate.Context

        init(req: Request, acronyms: [Acronym]) throws {
            self.base = try .init(title: "Home page", req: req)
            self.acronyms = .init(acronyms: acronyms)
        }
    }

    func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(
                content:

                img.src("/images/logo.png").class("mx-auto d-block").alt("TIL Logo"),
                h1.child(
                    "Acronyms"
                ),

                // List of acronyms
                embed(
                    AcronymListTemplate(),
                    withPath: \.acronyms
                )
            ),
            withPath: \.base)
    }
}
