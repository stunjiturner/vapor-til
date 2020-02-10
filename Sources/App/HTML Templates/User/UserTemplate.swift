import BootstrapKit
import Vapor

extension User {
    fileprivate var profilePictureUri: String? {
        guard
            let id = id,
            profilePicture != nil
        else {
            return nil
        }
        return "/users/\(id)/profilePicture"
    }

    fileprivate var addProfilePictureUri: String {
        guard let id = id else {
            return ""
        }
        return "/users/\(id)"
    }
}

extension User.Templates {
    struct Details: HTMLTemplate {

        struct Context {
            let user: User
            let base: BaseTemplate.Context
            let acronyms: [Acronym]

            init(user: User, acronyms: [Acronym], req: Request) throws {
                self.user = user
                self.base = try .init(title: user.name, req: req)
                self.acronyms = acronyms
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {

                Unwrap(context.user.profilePictureUri) { profilePictureUri in
                    Img().source(profilePictureUri).alt(context.user.name)
                }

                Text {
                    context.user.name
                }.style(.heading1)

                Text {
                    context.user.username
                }.style(.heading2)

                IF(context.base.userLoggedIn) {
                    Anchor {
                        IF(context.user.profilePicture != nil) {
                            "Update "
                        }.else {
                            "Add "
                        }
                        "Profile Picture"
                    }.href(context.user.addProfilePictureUri)
                }

                Acronym.Templates.List(context: context.acronyms)
            }
        }
    }
}
