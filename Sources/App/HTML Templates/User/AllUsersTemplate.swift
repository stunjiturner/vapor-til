import BootstrapKit
import Vapor

extension User {
    fileprivate var detailUri: String {
        guard let id = id else {
            return ""
        }
        return "/users/\(id)"
    }
}

extension User.Templates {

    struct ListAll: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let users: [User]

            init(users: [User], req: Request) throws {
                self.users = users
                self.base = try .init(title: "All Users", req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    "All Users"
                }
                .style(.heading1)

                IF(context.users.isEmpty) {
                    Text {
                        "There aren't any users yet!"
                    }
                }
                .else {
                    Row {
                        ForEach(in: context.users) { user in
                            Div {
                                UserCard(user: user)
                            }.column(width: .four, for: .large)
                        }
                    }
                }
            }
        }

        struct UserCard: HTMLComponent {

            let user: TemplateValue<User>

            var body: HTML {
                Anchor {
                    Card {
                        Text {
                            user.username
                        }
                        .style(.cardTitle)
                        .text(color: .dark)

                        Text {
                            user.name
                        }.style(.cardText)
                    }
                }.href(user.detailUri)
            }
        }
    }
}
