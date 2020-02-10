import BootstrapKit
import Vapor

extension User.Templates {
    struct ResetPassword: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let isError: Bool

            init(req: Request, isError: Bool = false) throws {
                self.base = try .init(title: "", req: req)
                self.isError = isError
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                IF(context.isError) {
                    Alert {
                        "here was a problem with the form. Ensure you clicked on the full link with the token and your passwords match."
                    }
                    .background(color: .danger)
                }

                Form {
                    FormGroup(label: "Password") {
                        Input()
                            .type(.text)
                            .id("password")
                    }

                    FormGroup(label: "Confirm Password") {
                        Input()
                            .type(.password)
                            .id("confirmPassword")
                    }

                    Button {
                        "Reset"
                    }
                    .type(.submit)
                    .button(style: .primary)
                }
                .method(.post)
            }
        }
    }
}
