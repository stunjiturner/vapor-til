//
//  AcronymListTemplate.swift
//  App
//
//  Created by Mats Mollestad on 03/03/2019.
//

import HTMLKit
import Vapor

struct AcronymListTemplate: ContextualTemplate {

    struct Context {
        let acronyms: [Acronym]
    }

    func build() -> CompiledTemplate {
        return
            runtimeIf(
                \.acronyms.count > 0,

                table.class("table table-bordered table-hover").child(
                    thead.class("thead-light").child(
                        tr.child(
                            th.child("Short"),
                            th.child("Long")
                        )
                    ),

                    // All the rows
                    tbody.child(
                        forEach(in:     \.acronyms,
                                render: AcronymRow()
                        )
                    )
                )
            ).else(
                    "There aren’t any acronyms yet!"
            )
    }

    
    // MARK: - Sub views

    struct AcronymRow: ContextualTemplate {

        typealias Context = Acronym

        func build() -> CompiledTemplate {
            return
                tr.child(
                    td.child(
                        a.href(["/acronyms/", variable(\.id)]).child(
                            variable(\.short)
                        )
                    ),
                    td.child(
                        variable(\.long)
                    )
            )
        }
    }
}
