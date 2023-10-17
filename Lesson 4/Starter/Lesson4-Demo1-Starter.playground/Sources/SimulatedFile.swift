public class SimulatedFile {
  public var fileName: String
  public var numberOfLines: Int

  public init(fileName: String) {
    self.fileName = fileName
    self.numberOfLines = 0
  }

  public func openFile() {
  }

  public func closeFile() {
  }

  public func writeData(_ data: String) {
  }
}
