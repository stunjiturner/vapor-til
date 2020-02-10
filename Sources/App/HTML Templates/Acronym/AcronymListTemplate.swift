import BootstrapKit
import Vapor

extension Acronym {
    enum Templates {}
}

extension Acronym {
    fileprivate var detailsUri: String {
        "/acronyms/\(id ?? 0)"
    }
}

extension Acronym.Templates {
    struct List: HTMLTemplate {

        @TemplateValue([Acronym].self)
        var context

        var body: HTML {
            Container {
                IF(context.isEmpty) {
                    Text {
                        "There aren’t any acronyms yet!"
                    }
                    .style(.heading1)
                }
                .else {
                    Row {
                        ForEach(in: context) { acronym in
                            Div {
                                AcronymCard(acronym: acronym)
                            }.column(width: .four, for: .large)
                        }
                    }
                }
            }
        }

        struct AcronymCard: HTMLComponent {

            let acronym: TemplateValue<Acronym>

            var body: HTML {
                Anchor {
                    Card {
                        Text {
                            acronym.short
                        }
                        .style(.heading3)
                        .text(color: .dark)

                        Text {
                            acronym.long
                        }
                        .style(.heading3)

                        Button {
                            "Se more"
                        }
                        .button(style: .primary)
                    }
                }
                .href(acronym.detailsUri)
            }
        }
    }
}
