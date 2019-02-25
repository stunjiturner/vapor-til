import HTMLKit
import Vapor

class PageController {
    static let shared = try! PageController()

    private var renderer = HTML.Renderer()

    init() throws {
        try renderer.add(template: AcronymView())
        try renderer.add(template: AcronymTable())
        try renderer.add(template: AddProfilePictureView())
        try renderer.add(template: AllCategoriesView())
        try renderer.add(template: AllUsers())
        try renderer.add(template: CategoryView())
        try renderer.add(template: CreateAcronymView())
        try renderer.add(template: ForgottenPasswordView())
        try renderer.add(template: ForgottenPasswordConfirmedView())
        try renderer.add(template: IndexView())
        try renderer.add(template: LoginView())
        try renderer.add(template: RegisterView())
        try renderer.add(template: ResetPasswordView())
        try renderer.add(template: UserView())
    }

    func render<T>(_ template: T.Type, with context: T.Context) throws -> HTTPResponse where T : ContextualTemplate {
        return try HTTPResponse(body: renderer.render(T.self, with: context))
    }
}

extension HTML.AttributeNode {

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func integrity(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "ingegrity", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func crossorigin(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "crossorigin", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func multiple(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "crossorigin", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func dataTarget(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "data-target", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func dataToggle(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "data-toggle", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static func ariaControls(_ value: CompiledTemplate) -> HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "aria-controls", value: value)
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public static var active: HTML.AttributeNode {
        return HTML.AttributeNode(attribute: "active", value: nil)
    }
}

extension AttributableNode {
    func integrity(_ value: CompiledTemplate) -> Self {
        return add( .integrity(value))
    }

    func crossorigin(_ value: CompiledTemplate) -> Self {
        return add( .crossorigin(value))
    }

    func multiple(_ value: CompiledTemplate) -> Self {
        return add( .multiple(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func dataTarget(_ value: CompiledTemplate) -> Self {
        return add(.dataTarget(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func dataToggle(_ value: CompiledTemplate) -> Self {
        return add(.dataToggle(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func ariaControls(_ value: CompiledTemplate) -> Self {
        return add(.ariaControls(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public var active: Self {
        return add( .active)
    }
}


struct BaseView: ContextualTemplate {

    struct Context {
        let title: String
        let userLoggedIn: Bool
        let showCookieMessage: Bool

        init(title: String = "Acronyms", req: Request) throws {
            self.title = title
            self.userLoggedIn = try req.isAuthenticated(User.self)
            self.showCookieMessage = req.http.cookies["cookies-accepted"] == nil
        }
    }

    let content: CompiledTemplate

    func build() -> CompiledTemplate {
        return [
            doctype("html"),
            html.lang("en").child(
                head.child(
                    meta.charset("utf-8"),
                    meta.name("viewport").content("width=device-width, initial-scale=1, shrink-to-fit=no"),
                    link.rel("stylesheet").href("https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css").integrity("sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO").crossorigin("anonymous").type("text/css"),

                    renderIf(
                        \.title == "Create An Acronym" || \.title == "Edit Acronym",

                        link.rel("stylesheet").href("https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css").integrity("sha384-RdQbeSCGSeSdSlTMGnUr2oDJZzOuGjJAkQy1MbKMu8fZT5G0qlBajY0n0sY/hKMK").crossorigin("anonymous").type("text/css")
                    ),

                    link.rel("stylesheet").href("/styles/style.css").type("text/css"),
                    title.child(
                        variable(\.title), " | Acronyms"
                    ),
                    body.child(
                        nav.class("navbar navbar-expand-md navbar-dark bg-dark").child(
                            a.class("navbar-brand").href("/").child(
                                "TIL"
                            ),
                            button.class("navbar-toggler").type("button").dataToggle("collapse").dataTarget("#navbarSupportedContent").ariaControls("navbarSupportedContent").child(
                                span.class("navbar-toggler-icon")
                            ),
                            div.class("collapse navbar-collapse").id("navbarSupportedContent").child(
                                ul.class("navbar-nav mr-auto").child(

                                    dynamic(li.class("nav-item"))
                                        .if(\.title == "Home page", add: .active).child(
                                            a.href("/").class("nav-link").child(
                                                "Home"
                                            )
                                    ),
                                    dynamic(li.class("nav-item"))
                                        .if(\.title == "All Users", add: .active).child(
                                            a.href("/users").class("nav-link").child(
                                                "All Users"
                                            )
                                    ),
                                    dynamic(li.class("nav-item"))
                                        .if(\.title == "All Categories", add: .active).child(
                                            a.href("/categories").class("nav-link").child(
                                                "All Categories"
                                            )
                                    ),
                                    dynamic(li.class("nav-item"))
                                        .if(\.title == "Create An Acronym", add: .active).child(
                                            a.href("/acronyms/create").class("nav-link").child(
                                                "Create An Acronym"
                                            )
                                    ),
                                    renderIf(
                                        \.userLoggedIn == false,
                                        dynamic(li.class("nav-item"))
                                            .if(\.title == "Register", add: .active).child(
                                                a.href("/register").class("nav-link").child(
                                                    "Register"
                                                )
                                        )
                                    )
                                ),
                                renderIf(
                                    \.userLoggedIn,
                                    form.class("form-inline").action("/logout").method("post").child(
                                        input.class("nav-link btn").type("submit").value("Log out")
                                    )
                                )
                            )
                        ),
                        div.class("container mt-3").child(
                            content
                        ),

                        renderIf(
                            \.showCookieMessage,
                            div.id("cookieMessage").class("container").child(
                                span.class("muted").child(
                                    "This site uses cookies! To accept this, click ",
                                    a.href("#").onclick("cookiesConfirmed()").child(
                                        "OK"
                                    )
                                )
                            ),
                            script.src("/scripts/cookies.js").type("text/javascript")
                        ),
                        script.src("https://code.jquery.com/jquery-3.3.1.min.js").integrity("sha384-tsQFqpEReu7ZLhBV2VZlAu7zcOV+rXbYlF2cqB8txI/8aZajjp4Bqd+V6D5IgvKT").crossorigin("anonymous").type("text/javascript"),

                        renderIf(
                            \.title == "Create An Acronym" || \.title == "Edit Acronym",

                            script.src("https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js").integrity("sha384-uQwKPrmNkEOvI7rrNdCSs6oS1F3GvnZkmPtkntOSIiPQN4CCbFSxv+Bj6qe0mWDb").crossorigin("anonymous").type("text/javascript"),
                            script.src("/scripts/createAcronym.js").type("text/javascript")
                        ),
                        script.src("https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js").integrity("sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49").crossorigin("anonymous").type("text/javascript"),
                        script.src("https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js").integrity("sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy").crossorigin("anonymous").type("text/javascript")
                    )
                )
        )]
    }
}

struct AcronymView: ContextualTemplate {

    struct CatagoryView: ContextualTemplate {

        typealias Context = Category

        func build() -> CompiledTemplate {
            return
                li.child(
                    a.href(["/categories/", variable(\.id)]).child(
                        variable(\.name)
                    )
            )
        }
    }

    struct Context {
        let acronym: Acronym
        let user: User
        let categories: [Category]
        let base: BaseView.Context

        init(req: Request, user: User, acronym: Acronym, categories: [Category]) throws {
            self.acronym = acronym
            self.user = user
            self.categories = categories
            self.base = try .init(title: acronym.short, req: req)
        }
    }

    func build() -> CompiledTemplate {

        return
            BaseView(content: [
                h1.child(variable(\.acronym.short)),
                h2.child(variable(\.acronym.long)),
                p.child(
                    "Created by ",
                    a.href(["/users/", variable(\.user.id)]).child(
                        variable(\.user.name)
                    )
                ),
                renderIf(
                    \.categories.count > 0,
                    h3.child("Categories"),
                    ul.child(
                        forEach(in:     \.categories,
                                render: CatagoryView()
                        )
                    )
                ),
                form.method("post").action(["/acronyms/", variable(\.acronym.id), "/delete"]).child(
                    a.class("btn btn-primary").href(["/acronyms/", variable(\.acronym.id) ,"/edit"]).role("button").child("Edit"),
                    "  ",
                    input.class("btn btn-danger").type("submit").value("Delete")
                )
        ]).embed(withPath: \Context.base)
    }
}

struct AcronymTable: ContextualTemplate {

    struct AcronymCell: ContextualTemplate {

        typealias Context = Acronym

        func build() -> CompiledTemplate {
            return
                tr.child(
                    td.child(
                        a.href(["/acronyms/", variable(\.id)]).child(
                            variable(\.short)
                        )
                    ),
                    td.child(
                        variable(\.long)
                    )
            )
        }
    }

    struct Context {
        let acronyms: [Acronym]
    }

    func build() -> CompiledTemplate {
        return [
            renderIf(
                \.acronyms.count > 0,
                table.class("table table-bordered table-hover").child(
                    thead.class("thead-light").child(
                        tr.child(
                            th.child("Short"),
                            th.child("Long")
                        )
                    ),
                    tbody.child(
                        forEach(in:     \.acronyms,
                                render: AcronymCell()
                        )
                    )
                )
            ).else(
                "There aren’t any acronyms yet!"
            )
        ]
    }
}

struct AddProfilePictureView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context
        let username: String

        init(username: String, req: Request) throws {
            self.username = username
            self.base = try .init(title: "Add Profile Picture", req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            form.method("post").enctype("multipart/form-data").child(
                div.class("form-group").child(
                    label.for("picture").child(
                        "Select Picture for ", variable(\.username)
                    ),
                    input.type("file").name("picture").class("form-control-file").id("picture")),
                button.type("submit").class("btn btn-primary").child(
                    "Upload"
                )
            )
        ]).embed(withPath: \Context.base)
    }
}

struct AllCategoriesView: ContextualTemplate {

    struct CategoryRow: ContextualTemplate {

        typealias Context = Category

        func build() -> CompiledTemplate {
            return
                tr.child(
                    td.child(
                        a.href(["/categories/", variable(\.id)]).child(
                            variable(\.name))))
        }
    }

    struct Context {
        let categories: [Category]
        let base: BaseView.Context

        init(categories: [Category], req: Request) throws {
            self.categories = categories
            self.base = try .init(title: "All Categories", req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child("All Categories"),

            renderIf(
                \.categories.count > 0,
                table.class("table table-bordered table-hover").child(
                    thead.class("thead-light").child(
                        tr.child(
                            th.child("Name")
                        )
                    ),
                    tbody.child(
                        // 3
                        forEach(in:     \.categories,
                                render: CategoryRow()
                        )
                    )
                )
            ).else(
                h2.child(
                    "There aren't any categories yet!"
                )
            )
        ]).embed(withPath: \Context.base)
    }
}


struct AllUsers: ContextualTemplate {

    struct UserRowView: ContextualTemplate {
        typealias Context = User

        func build() -> CompiledTemplate {

            return
                tr.child(
                    td.child(
                        a.href(["/users/", variable(\.id)]).child(
                            variable(\.username)
                        )
                    ),
                    td.child(
                        variable(\.name)
                    )
            )
        }
    }

    struct Context {
        let base: BaseView.Context
        let users: [User]

        init(users: [User], req: Request) throws {
            self.users = users
            self.base = try .init(title: "All Users", req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child("All Users"),

            renderIf(
                \.users.count > 0,
                table.class("table table-bordered table-hover").child(
                    thead.class("thead-light").child(
                        tr.child(
                            th.child("Username"),
                            th.child("Name")
                        )
                    ),
                    tbody.child(
                        forEach(in:     \.users,
                                render: UserRowView()
                        )
                    )
                )
            ).else(
                h2.child(
                    "There aren't any users yet!"
                )
            )
        ]).embed(withPath: \Context.base)
    }
}

struct CategoryView: ContextualTemplate {

    struct Context {
        let category: Category
        let base: BaseView.Context
        var table: AcronymTable.Context

        init(category: Category, acronyms: [Acronym], req: Request) throws {
            self.category = category
            self.table = .init(acronyms: acronyms)
            self.base = try .init(title: category.name, req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h2.child(
                variable(\.category.name)
            ),
            AcronymTable().embed(withPath: \Context.table)
        ]).embed(withPath: \Context.base)
    }
}


struct CreateAcronymView: ContextualTemplate {

    struct CategoryOption: ContextualTemplate {

        typealias Context = Category

        func build() -> CompiledTemplate {
            return
                option.value( variable(\.name)).selected.child(
                    variable(\.name)
            )
        }
    }

    struct Context {
        let base: BaseView.Context
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

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            form.method("post").child(
                renderIf(
                    \.csrfToken != nil,
                    input.type("hidden").name("csrfToken").value(
                        variable(\.csrfToken)
                    )
                ),
                div.class("form-group").child(
                    label.for("short").child(
                        "Acronym"
                    ),
                    input.type("text").name("short").class("form-control").id("short")
                ),
                div.class("form-group").child(
                    label.for("long").child(
                        "Meaning"
                    ),
                    input.type("text").name("long").class("form-control").id("long")
                ),
                div.class("form-group").child(
                    label.for("categories").child(
                        "Categories"
                    ),
                    select.name("categories[]").class("form-control").id("categories").placeholder("Categories").multiple("multiple").child(
                        forEach(in:     \.categories,
                                render: CategoryOption()
                        )
                    )
                ),
                button.type("submit").class("btn btn-primary").child(
                    renderIf(
                        \.isEditing,
                        "Update"
                    ).else(
                        "Submit"
                    )
                )
            )
            ]).embed(withPath: \Context.base)
    }
}


struct ForgottenPasswordView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context

        init(req: Request) throws {
            self.base = try .init(title: "Reset Your Password", req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            form.method("post").child(
                div.class("form-group").child(
                    label.for("email").child(
                        "Email"
                    ),
                    input.type("email").name("email").class("form-control").id("email")
                ),
                button.type("submit").class("btn btn-primary").child(
                    "Reset Password"
                )
            )
            ]).embed(withPath: \Context.base)
    }
}

struct ForgottenPasswordConfirmedView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context

        init(req: Request) throws {
            self.base = try .init(title: "Password Reset Email Sent", req: req)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            p.child(
                "Instructions to reset your password have been emailed to you."
            )
            ]).embed(withPath: \Context.base)
    }
}


struct IndexView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context
        let acronyms: AcronymTable.Context

        init(req: Request, acronyms: [Acronym]) throws {
            self.base = try .init(title: "Home page", req: req)
            self.acronyms = .init(acronyms: acronyms)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            img.src("/images/logo.png").class("mx-auto d-block").alt("TIL Logo"),
            h1.child(
                "Acronyms"
            ),
            AcronymTable().embed(withPath: \Context.acronyms)
            ]).embed(withPath: \Context.base)
    }
}

struct LoginView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context
        let hasError: Bool

        init(req: Request, hasError: Bool = false) throws {
            self.base = try .init(title: "Log In", req: req)
            self.hasError = hasError
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            renderIf(
                \.hasError,
                div.class("alert alert-danger").role("alert").child(
                    "User authentication error. Either your username or password was invalid."
                )
            ),
            form.method("post").child(
                div.class("form-group").child(
                    label.for("username").child(
                        "Username"
                    ),
                    input.type("text").name("username").class("form-control").id("username")),
                div.class("form-group").child(
                    label.for("password").child(
                        "Password"
                    ),
                    input.type("password").name("password").class("form-control").id("password")),
                button.type("submit").class("btn btn-primary").child(
                    "Log In"
                )
            ),
            a.href("/login-google").child(
                img.class("mt-3").src("/images/sign-in-with-google.png").alt("Sign In With Google")
            ),
            a.href("/login-github").child(
                img.class("mt-3").src("/images/sign-in-with-github.png").alt("Sign In With GitHub")
            ),
            br,
            a.href("/forgottenPassword").child(
                "Forgotten your password?"
            )
            ]).embed(withPath: \Context.base)
    }
}

struct RegisterView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context
        let message: String?

        init(req: Request, message: String? = nil) throws {
            self.base = try .init(title: "Register", req: req)
            self.message = message
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            renderIf(
                \.message != nil,
                div.class("alert alert-danger").role("alert").child(
                    "Please fix the following errors:",
                    variable(\.message)
                )
            ),
            form.method("post").child(
                div.class("form-group").child(
                    label.for("name").child(
                        "Name"
                    ),
                    input.type("text").name("name").class("form-control").id("name")
                ),
                div.class("form-group").child(
                    label.for("username").child(
                        "Username"
                    ),
                    input.type("text").name("username").class("form-control").id("username")
                ),
                div.class("form-group").child(
                    label.for("emailAddress").child(
                        "Email Address"
                    ),
                    input.type("email").name("emailAddress").class("form-control").id("emailAddress")
                ),
                div.class("form-group").child(
                    label.for("password").child(
                        "Password"
                    ),
                    input.type("password").name("password").class("form-control").id("password")
                ),
                div.class("form-group").child(
                    label.for("confirmPassword").child(
                        "Confirm Password"
                    ),
                    input.type("password").name("confirmPassword").class("form-control").id("confirmPassword")
                ),
                button.type("submit").class("btn btn-primary").child(
                    "Register"
                )
            )
            ]).embed(withPath: \Context.base)
    }
}

struct ResetPasswordView: ContextualTemplate {

    struct Context {
        let base: BaseView.Context
        let isError: Bool

        init(req: Request, isError: Bool = false) throws {
            self.base = try .init(title: "", req: req)
            self.isError = isError
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            h1.child(
                variable(\.base.title)
            ),
            renderIf(
                \.isError,
                div.class("alert alert-danger").role("alert").child(
                    "There was a problem with the form. Ensure you clicked on the full link with the token and your passwords match."
                )
            ),
            form.method("post").child(
                div.class("form-group").child(
                    label.for("password").child(
                        "Password"
                    ),
                    input.type("password").name("password").class("form-control").id("password")),
                div.class("form-group").child(
                    label.for("confirmPassword").child(
                        "Confirm Password"
                    ),
                    input.type("password").name("confirmPassword").class("form-control").id("confirmPassword")),
                button.type("submit").class("btn btn-primary").child(
                    "Reset"
                )
            )
            ]).embed(withPath: \Context.base)
    }
}

struct UserView: ContextualTemplate {

    struct Context {
        let user: User
        let base: BaseView.Context
        let table: AcronymTable.Context

        init(user: User, acronyms: [Acronym], req: Request) throws {
            self.user = user
            self.base = try .init(title: user.name, req: req)
            self.table = .init(acronyms: acronyms)
        }
    }

    func build() -> CompiledTemplate {
        return BaseView(content: [
            renderIf(
                \.user.profilePicture != nil,
                img.src(["/users/", variable(\.user.id), "/profilePicture"]).alt( variable(\.user.name))
            ),
            h1.child(
                variable(\.user.name)
            ),
            h2.child(
                variable(\.user.username)
            ),
            renderIf(
                \.base.userLoggedIn,
                a.href(["/users/", variable(\.user.id), "/addProfilePicture"]).child(
                    renderIf(
                        \.user.profilePicture != nil,
                        "Update "
                    ).else(
                        "Add "
                    ),
                    "Profile Picture"
                )
            ),
            AcronymTable().embed(withPath: \Context.table)
            ]).embed(withPath: \Context.base)
    }
}
