import BootstrapKit
import Vapor

extension User.Templates {
    struct AddProfilePicture: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let username: String

            init(username: String, req: Request) throws {
                self.username = username
                self.base = try .init(title: "Add Profile Picture", req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                Form {
                    FormGroup(label: "Select Picture for " + context.username) {
                        Input()
                            .type(.file)
                            .id("picture")
                            .class("form-control-file")
                    }

                    Button {
                        "Upload"
                    }
                    .type(.submit)
                    .button(style: .primary)
                }
            }
        }
    }
}
