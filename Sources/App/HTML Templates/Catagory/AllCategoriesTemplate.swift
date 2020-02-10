import BootstrapKit
import Vapor

extension Category {
    enum Templates {}

    fileprivate var detailsUri: String {
        "/categories/\(id ?? 0)"
    }
}

extension Category.Templates {
    struct ListAll: HTMLTemplate {

        struct Context {
            let categories: [Category]
            let base: BaseTemplate.Context

            init(categories: [Category], req: Request) throws {
                self.categories = categories
                self.base = try .init(title: "All Categories", req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.base.title
                }
                .style(.heading1)

                IF(context.categories.isEmpty) {
                    Text {
                        "There aren't any categories yet!"
                    }
                    .style(.heading2)
                }
                .else {
                    Row {
                        ForEach(in: context.categories) { category in
                            Div {
                                CategoryCard(category: category)
                            }.column(width: .three, for: .large)
                        }
                    }
                }

            }
        }

        struct CategoryCard: HTMLComponent {

            let category: TemplateValue<Category>

            var body: HTML {
                Anchor {
                    Card {
                        Text {
                            category.name
                        }
                    }
                }.href(category.detailsUri)
            }
        }
    }
}
