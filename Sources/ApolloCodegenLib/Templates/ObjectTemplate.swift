import Foundation
import GraphQLCompiler
import TemplateString

/// Provides the format to convert a [GraphQL Object](https://spec.graphql.org/draft/#sec-Objects)
/// into Swift code.
struct ObjectTemplate: TemplateRenderer {
  /// IR representation of source [GraphQL Object](https://spec.graphql.org/draft/#sec-Objects).
  let graphqlObject: GraphQLObjectType

  let config: ApolloCodegen.ConfigurationContext

  let target: TemplateTarget = .schemaFile(type: .object)

  func renderBodyTemplate(
    nonFatalErrorRecorder: ApolloCodegen.NonFatalError.Recorder
  ) -> TemplateString {    
    """
    \(documentation: graphqlObject.documentation, config: config)
    static let \(graphqlObject.formattedName) = \(config.ApolloAPITargetName).Object(
      typename: "\(graphqlObject.name)\",
      implementedInterfaces: \(ImplementedInterfacesTemplate())
    )
    """
  }

  private func ImplementedInterfacesTemplate() -> TemplateString {
    return """
    [\(list: graphqlObject.interfaces.map({ interface in
          TemplateString("""
          \(if: !config.output.schemaTypes.isInModule, "\(config.schemaNamespace.firstUppercased).")\
          Interfaces.\(interface.formattedName).self
          """)
      }))]
    """
  }
}
