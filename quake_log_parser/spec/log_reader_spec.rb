require 'quake_log_parser/log_reader'

RSpec.describe QuakeLogParser::LogReader do
  describe ".safe_read_log" do
    context "when the file is empty" do
      it "raises an exception with the expected message" do
        allow(File).to receive(:readlines).and_return([])
        expect { QuakeLogParser::LogReader.safe_read_log('empty_file') }.to raise_error(RuntimeError, "File is empty")
      end
    end

    context "when the file does not exist" do
      it "raises an exception for a missing file" do
        allow(File).to receive(:readlines).and_raise(Errno::ENOENT)
        expect { QuakeLogParser::LogReader.safe_read_log('nonexistent_file') }.to raise_error(RuntimeError, "File not found: Ensure the file path is correct.")
      end
    end
  end
end
