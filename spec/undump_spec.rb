require 'minitest/autorun'
require 'expletive'
require 'stringio'

include Expletive

describe Undump do
  def dedump(input)
    in_io = StringIO.new(input)
    out_io = StringIO.new
    Undump.new(in_io, out_io).run
    out_io.string
  end
 
  describe "#run" do
    it "passes text unchanged" do
      input = "hello world"
      assert_equal input, dedump(input)
    end

    it "decodes hex into equivalent binary" do
      input = "\\01\\02\\03xyz"
      output = "\01\02\03xyz"
      assert_equal output, dedump(input)
    end

    it "turns backslash backslash into a single backslash" do
      input = 'abc\\\\def'
      output = 'abc\\def'
      assert_equal output, dedump(input)
    end

    it "turns backslash n into a real newline" do
      input = "abc\\ndef"
      output = "abc\ndef"
      assert_equal output, dedump(input)
    end
  end
end
