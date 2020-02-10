import BootstrapKit
import Vapor

extension Category.Templates {
    struct Details: HTMLTemplate {

        struct Context {
            let category: Category
            let base: BaseTemplate.Context
            let acronyms: [Acronym]

            init(category: Category, acronyms: [Acronym], req: Request) throws {
                self.category = category
                self.acronyms = acronyms
                self.base = try .init(title: category.name, req: req)
            }
        }

        var body: HTML {
            BaseTemplate(context: context.base) {
                Text {
                    context.category.name
                }
                .style(.heading2)

                Acronym.Templates.List(context: context.acronyms)
            }
        }
    }
}
