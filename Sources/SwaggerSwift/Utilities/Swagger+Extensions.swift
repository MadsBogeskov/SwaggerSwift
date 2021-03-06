import SwaggerSwiftML

extension Swagger {
    /// The name of the service the Swagger file exposes
    var serviceName: String {
        info.title.replacingOccurrences(of: " ", with: "")
    }

    func findParameter(node: Node<Parameter>) -> Parameter {
        switch node {
        case .reference(let reference):
            for (key, value) in self.parameters ?? [:] {
                let searchName = "#/parameters/\(key)"
                if reference == searchName {
                    return value
                }
            }

            fatalError("Failed to find parameter named: \(reference)")
        case .node(let node):
            return node
        }
    }

    func findSchema(node: Node<Schema>) -> Schema {
        switch node {
        case .reference(let reference):
            for (key, value) in self.definitions ?? [:] {
                let searchName = "#/definitions/\(key)"
                if reference == searchName {
                    return value
                }
            }

            for (key, value) in self.responses ?? [:] {
                let searchName = "#/responses/\(key)"
                if reference == searchName, let schemaNode = value.schema {
                    return findSchema(node: schemaNode)
                }
            }

            fatalError("Failed to find definition named: \(reference)")
        case .node(let node):
            return node
        }
    }
}
