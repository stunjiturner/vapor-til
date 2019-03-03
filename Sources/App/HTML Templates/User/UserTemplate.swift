//
//  UserTemplate.swift
//  App
//
//  Created by Mats Mollestad on 03/03/2019.
//

import HTMLKit
import Vapor


struct UserTemplate: ContextualTemplate {

    struct Context {
        let user: User
        let base: BaseTemplate.Context
        let table: AcronymListTemplate.Context

        init(user: User, acronyms: [Acronym], req: Request) throws {
            self.user = user
            self.base = try .init(title: user.name, req: req)
            self.table = .init(acronyms: acronyms)
        }
    }

    func build() -> CompiledTemplate {
        return embed(
            BaseTemplate(
                content:

                // Profile Picture
                runtimeIf(
                    \.user.profilePicture != nil,

                    img.src("/users/", variable(\.user.id), "/profilePicture").alt( variable(\.user.name))
                ),

                h1.child(
                    variable(\.user.name)
                ),

                h2.child(
                    variable(\.user.username)
                ),

                // Update or Add profile picture
                runtimeIf(
                    \.base.userLoggedIn,

                    a.href("/users/", variable(\.user.id), "/addProfilePicture").child(
                        runtimeIf(
                            \.user.profilePicture != nil,
                            "Update "
                        ).else(
                            "Add "
                        ),
                        "Profile Picture"
                    )
                ),

                // List of Acronyms
                embed(
                    AcronymListTemplate(),
                    withPath: \.table
                )
            ),
            withPath: \.base)
    }
}
