import BootstrapKit
import Vapor


extension User.Templates {
    struct ForgottenPassword: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context

            init(req: Request) throws {
                self.base = try .init(title: "Reset Your Password", req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                Form {
                    FormGroup(label: "Email") {
                        Input()
                            .type(.email)
                            .id("email")
                    }

                    Button {
                        "Reset Password"
                    }
                    .button(style: .primary)
                    .type(.submit)
                }
                .method(.post)
            }
        }
    }
}
