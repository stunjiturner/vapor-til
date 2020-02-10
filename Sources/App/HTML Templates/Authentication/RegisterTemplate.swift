import BootstrapKit
import Vapor

extension User.Templates {
    struct Register: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let message: String?

            init(req: Request, message: String? = nil) throws {
                self.base = try .init(title: "Register", req: req)
                self.message = message
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                Unwrap(context.message) { errorMessage in

                    Alert {
                        "Please fix the following errors:"
                        errorMessage
                    }
                    .background(color: .danger)
                }

                Form {
                    FormGroup(label: "Name") {
                        Input()
                            .type(.text)
                            .id("name")
                    }

                    FormGroup(label: "Username") {
                        Input()
                            .type(.text)
                            .id("username")
                    }

                    FormGroup(label: "Email") {
                        Input()
                            .type(.email)
                            .id("emailAddress")
                    }

                    FormGroup(label: "Password") {
                        Input()
                            .type(.password)
                            .id("password")
                    }

                    FormGroup(label: "Confirm Password") {
                        Input()
                            .type(.password)
                            .id("confirmPassword")
                    }

                    Button {
                        "Register"
                    }
                    .type(.submit)
                    .button(style: .primary)
                }
                .method(.post)
            }
        }
    }
}
