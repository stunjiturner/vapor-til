import BootstrapKit
import Vapor

extension User {
    enum Templates {}
}

extension User.Templates {
    struct ForgottenPasswordConfirmed: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context

            init(req: Request) throws {
                self.base = try .init(title: "Password Reset Email Sent", req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                Text {
                    "Instructions to reset your password have been emailed to you."
                }
            }
        }
    }
}
