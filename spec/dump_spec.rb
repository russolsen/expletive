require 'minitest/autorun'
require 'expletive'
require 'stringio'

include Expletive

describe Dump do
  def endump(input)
    in_io = StringIO.new(input)
    out_io = StringIO.new
    Dump.new(in_io, out_io).run
    out_io.string
  end
 
  describe "#dump" do
    it "passes text unchanged" do
      input = "hello world"
      assert_equal input, endump(input)
    end

    it "encodes binary into hex" do
      input = "\01\02\03xyz"
      assert_equal '\\01\\02\\03xyz', endump(input)
    end

    it "escapes backslashes" do
      input = 'abc\\def'
      assert_equal 'abc\\\\def', endump(input)
    end

    it "escapes newlines" do
      input = "abc\ndef"
      assert_equal 'abc\\ndef', endump(input)
    end
  end
end
