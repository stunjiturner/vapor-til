
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

extension Category {
    fileprivate var detailUri: String {
        "/categories/\(id ?? 0)"
    }
}

extension Acronym {
    fileprivate var deleteUri: String {
        "/acronyms/\(id ?? 0)/delete"
    }

    fileprivate var editUri: String {
        "/acronyms/\(id ?? 0)/edit"
    }
}

extension Acronym.Templates {

    struct Details: HTMLTemplate {

        struct Context {
            let acronym: Acronym
            let user: User
            let categories: [Category]
            let base: BaseTemplate.Context

            init(req: Request, user: User, acronym: Acronym, categories: [Category]) throws {
                self.acronym = acronym
                self.user = user
                self.categories = categories
                self.base = try .init(title: acronym.short, req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.acronym.short
                }
                .style(.heading1)

                Text {
                    context.acronym.long
                }
                .style(.heading2)

                Text {
                    "Created by "
                    Anchor {
                        context.user.name
                    }
                    .href(context.user.detailUri)
                }

                IF(context.categories.isEmpty == false) {
                    Text {
                        "Categories"
                    }
                    .style(.heading3)

                    UnorderedList {
                        ForEach(in: context.categories) { category in
                            CatagoryView(category: category)
                        }
                    }
                }

                Form {
                    Anchor {
                        "Edit"
                    }
                    .button(style: .primary)
                    .href(context.acronym.editUri)
                    .role("button")

                    Button {
                        "Delete"
                    }
                    .button(style: .danger)
                    .type(.submit)
                    .margin(.one, for: .left)
                }
                .method(.post)
                .action(context.acronym.deleteUri)
            }
        }
    }

    struct CatagoryView: HTMLComponent {

        let category: TemplateValue<Category>

        var body: HTML {
            ListItem {
                Anchor {
                    category.name
                }
                .href(category.detailUri)
            }
        }
    }
}
