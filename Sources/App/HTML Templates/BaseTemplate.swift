import Vapor
import BootstrapKit


struct BaseTemplate: HTMLComponent {

    /// The context needed to render a base template
    struct Context {
        let title: String
        let userLoggedIn: Bool
        let showCookieMessage: Bool

        var modifyAcronym: Bool {
            title == "Create An Acronym" || title == "Edit Acronym"
        }

        init(title: String = "Acronyms", req: Request) throws {
            self.title = title
            self.userLoggedIn = try req.isAuthenticated(User.self)
            self.showCookieMessage = req.http.cookies["cookies-accepted"] == nil
        }
    }

    var navigationBarItems: [NavigationBarItem.Item] {
        [
            .init(title: "Home",            uri: "/",           isActive: context.title == "Home"),
            .init(title: "All Users",       uri: "/users",      isActive: context.title == "All Users"),
            .init(title: "All Categories",  uri: "/categories", isActive: context.title == "All Categories"),
            .init(title: "Register",        uri: "/register",   isActive: context.title == "Register"),
        ]
    }

    private let context: TemplateValue<Context>
    private let content: HTML

    public init(context: TemplateValue<Context>, @HTMLBuilder content: () -> HTML) {
        self.context = context
        self.content = content()
    }

    var body: HTML {
        Document(type: .html5) {
            Head {
                Viewport(.acordingToDevice)
                Stylesheet(url: "/styles/style.css")
                Stylesheet(url: "https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css")
                IF(context.modifyAcronym) {
                    Stylesheet(url: "https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css")
                }
                Title {
                    context.title
                    " | Acronyms"
                }
            }
            Body {
                NavigationBar {
                    NavigationBar.Brand(link: "/") {
                        "TIL"
                    }
                    NavigationBar.Collapse {
                        ForEach(in: navigationBarItems) { item in
                            NavigationBarItem(item: item)
                        }
                        IF(context.userLoggedIn) {
                            Form {
                                Button {
                                    "Log out"
                                }
                                .class("nav-link btn")
                                .type(.submit)
                            }
                            .action("/logout")
                            .method(.post)
                        }
                    }
                }

                Container {
                    content
                }
                .margin(.three, for: .top)

                IF(context.showCookieMessage) {
                    Container {
                        Span {
                            "This site uses cookies! To accept this, click "
                            Anchor {
                                "OK"
                            }
                            .href("#")
                            .on(click: "cookiesConfirmed()")
                        }
                    }
                    Script().source("/scripts/cookies.js").type("text/javascript")
                }

                Script().source("https://code.jquery.com/jquery-3.3.1.min.js").type("text/javascript")
                Script().source("https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js").type("text/javascript")
                Script().source("https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js").type("text/javascript")

                IF(context.modifyAcronym) {
                    Script().source("https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js").type("text/javascript")
                }
            }
        }
    }

    struct NavigationBarItem: HTMLComponent {

        struct Item {
            let title: String
            let uri: String
            let isActive: Conditionable
        }

        let item: TemplateValue<Item>

        var body: HTML {
            ListItem {
                Anchor {
                    item.title
                }
                .href(item.uri)
                .class("nav-link")
            }
            .class("nav-item")
        }
    }
}
