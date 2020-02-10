import BootstrapKit
import Vapor


extension User.Templates {
    struct Login: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let hasError: Bool

            init(req: Request, hasError: Bool = false) throws {
                self.base = try .init(title: "Log In", req: req)
                self.hasError = hasError
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                IF(context.hasError) {
                    Alert {
                        "User authentication error. Either your username or password was invalid."
                    }
                    .background(color: .danger)
                }

                Form {
                    FormGroup(label: "Username") {
                        Input()
                            .type(.text)
                            .id("username")
                    }

                    FormGroup(label: "Password") {
                        Input()
                            .type(.password)
                            .id("password")
                    }

                    Button {
                        "Log in"
                    }
                    .type(.submit)
                    .button(style: .primary)
                }
                .method(.post)

                Anchor {
                    Img(source: "/images/sign-in-with-google.png")
                        .alt("Sign In With Google")
                        .margin(.three, for: .top)
                }
                .href("/login-google")

                Anchor {
                    Img(source: "/images/sign-in-with-github.png")
                        .alt("Sign In With GitHub")
                        .margin(.three, for: .top)
                }
                .href("/login-github")

                Break()

                Anchor {
                    "Forgotten your password?"
                }
                .href("/forgottenPassword")
            }
        }
    }
}
