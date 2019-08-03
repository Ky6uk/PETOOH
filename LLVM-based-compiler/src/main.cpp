#include "input.hpp"
#include "ir.hpp"

#include <fstream>
#include <iostream>
#include <string>
#include <system_error>

#include <llvm/Bitcode/ReaderWriter.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/raw_ostream.h>

void hideExtraOptions() {
  llvm::StringMap<llvm::cl::Option *> &options =
      llvm::cl::getRegisteredOptions();
  options["help"]->setDescription("Display available options");
  options["help-list"]->setDescription("Display list of available options");
  options["version"]->setHiddenFlag(llvm::cl::Hidden);
  options["rng-seed"]->setHiddenFlag(llvm::cl::Hidden);
}

std::unique_ptr<llvm::Module> buildModuleFromFile(std::string const &filename,
                                                  uint64_t const byteCount) {
  std::ifstream inputStream(filename);
  if (!inputStream) {
    std::cerr << "Failed to open input file" << std::endl;
    exit(EXIT_FAILURE);
  }
  InstrList const instrs(readAndCheckInstructions(inputStream));
  return createMainLlvmModule(byteCount, instrs);
}

void writeModuleBitcodeToFile(llvm::Module const &module,
                              std::string const &filename) {
  std::error_code errorCode;
  llvm::raw_fd_ostream outputStream(filename, errorCode, llvm::sys::fs::F_RW);
  if (static_cast<bool>(errorCode)) {
    std::cerr << "Failed to write output file" << std::endl;
    exit(EXIT_FAILURE);
  }
  llvm::WriteBitcodeToFile(&module, outputStream);
}

int main(int argc, char *argv[]) {
  llvm::cl::opt<std::string> inputFilename(
      llvm::cl::Positional, llvm::cl::desc("<input file>"), llvm::cl::Required);
  llvm::cl::opt<std::string> outputFilename(
      "o", llvm::cl::desc("Specify output filename"),
      llvm::cl::value_desc("filename"), llvm::cl::Required);
  llvm::cl::opt<unsigned> byteCount(
      "b", llvm::cl::desc("Specify program memory size (32768 by default)"),
      llvm::cl::value_desc("bytes"), llvm::cl::init(32768));
  hideExtraOptions();
  llvm::cl::ParseCommandLineOptions(argc, argv,
                                    "PETOOH compiler to LLVM IR (bitcode)");

  auto const module(buildModuleFromFile(inputFilename, byteCount));
  writeModuleBitcodeToFile(*module, outputFilename);

  return 0;
}
