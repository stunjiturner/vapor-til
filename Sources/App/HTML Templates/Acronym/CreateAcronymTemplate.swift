import BootstrapKit
import Vapor

extension Acronym.Templates {
    struct Create: HTMLTemplate {

        struct Context {
            let base: BaseTemplate.Context
            let csrfToken: String?
            let categories: [Category]
            let isEditing: Bool

            init(req: Request, isEditing: Bool = false, categories: [Category] = []) throws {
                self.base = try .init(title: isEditing ? "Edit Acronym" : "Create An Acronym", req: req)
                self.csrfToken = try req.session()["CSRF_TOKEN"]
                self.isEditing = isEditing
                self.categories = categories
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                Form {
                    Unwrap(context.csrfToken) { token in
                        Input()
                            .type(.hidden)
                            .name("csrfToken")
                            .value(token)
                    }

                    FormGroup(label: "Acronym") {
                        Input()
                            .type(.text)
                            .id("short")
                    }

                    FormGroup(label: "Meaning") {
                        Input()
                            .type(.text)
                            .id("long")
                    }

                    FormGroup(label: "Categories") {
                        Select(context.categories) { category in
                            category.name
                        }
                        .isMultiple(true)
                        .id("categories")
                        .name("categories[]")
                    }
                }
                .method(.post)
            }
        }
    }
}
