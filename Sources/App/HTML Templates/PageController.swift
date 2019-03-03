import HTMLKit
import Vapor

class PageController {
    static let shared = try! PageController()

    private var renderer = HTMLRenderer()

    init() throws {
        try renderer.add(template: AcronymTemplate())
        try renderer.add(template: AcronymListTemplate())
        try renderer.add(template: AddProfilePictureTemplate())
        try renderer.add(template: AllCategoriesTemplate())
        try renderer.add(template: AllUsersTemplate())
        try renderer.add(template: CategoryTemplate())
        try renderer.add(template: CreateAcronymTemplate())
        try renderer.add(template: ForgottenPasswordTemplate())
        try renderer.add(template: ForgottenPasswordConfirmedTemplate())
        try renderer.add(template: IndexTemplate())
        try renderer.add(template: LoginTemplate())
        try renderer.add(template: RegisterTemplate())
        try renderer.add(template: ResetPasswordTemplate())
        try renderer.add(template: UserTemplate())
    }

    func render<T>(_ template: T.Type, with context: T.Context) throws -> HTTPResponse where T : ContextualTemplate {
        return try HTTPResponse(body: renderer.render(T.self, with: context))
    }
}

// Some extensions for non standard HTML attributes
extension AttributableNode {
    func integrity(_ value: CompiledTemplate...) -> Self {
        return add( .integrity(value))
    }

    func crossorigin(_ value: CompiledTemplate...) -> Self {
        return add( .crossorigin(value))
    }

    func multiple(_ value: CompiledTemplate...) -> Self {
        return add( .multiple(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func dataTarget(_ value: CompiledTemplate...) -> Self {
        return add(.dataTarget(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func dataToggle(_ value: CompiledTemplate...) -> Self {
        return add(.dataToggle(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public func ariaControls(_ value: CompiledTemplate...) -> Self {
        return add(.ariaControls(value))
    }

    /// - Parameter value: The value of the attribute
    /// - Returns: An attribute node
    public var active: Self {
        return add( .active)
    }
}

// Some extensions for non standard HTML attributes
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
