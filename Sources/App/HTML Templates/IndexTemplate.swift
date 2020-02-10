import BootstrapKit
import Vapor

struct IndexTemplate: HTMLTemplate {

    struct Context {
        let base: BaseTemplate.Context
        let acronyms: [Acronym]

        init(req: Request, acronyms: [Acronym]) throws {
            self.base = try .init(title: "Home page", req: req)
            self.acronyms = acronyms
        }
    }

    var body: HTML {
        BaseTemplate(context: context.base) {
            Img(source: "/images/logo.png")
                .display(.block)
                .margin(.auto, for: .horizontal)
                .alt("TIL Logo")
            Text {
                "Acronyms"
            }
            .style(.heading1)

            Acronym.Templates.List(context: context.acronyms)
        }
    }
}
