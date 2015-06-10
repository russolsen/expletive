module Expletive
  SPACE = ' '.ord
  TILDE = '~'.ord
  NEWLINE = "\n".ord
  BACKSLASH = "\\".ord

  class Dump
    def initialize(in_io=$stdin, out_io=$stdout)
      @in = in_io
      @out = out_io
      @current_width = 0
    end

    def run
      n = 0
      until @in.eof?
        byte = @in.readbyte
        case 
        when byte ==  BACKSLASH
          write_string "\\\\"
        when byte == NEWLINE
          write_string "\\n"
        when human_readable?(byte)
          write_string byte.chr 
        else
          write_string  "\\%02x" % byte
        end
      end
    end

    def start_new_line
      @out.print("\n")
      @current_width = 0
    end

    def write_string(s)
      @out.print(s)
      @current_width += s.size
      start_new_line if @current_width > 60
    end

    def human_readable?(byte)
      (byte >= SPACE) && (byte <= TILDE)
    end
  end

  class Undump
    def initialize(in_io=$stdin, out_io=$stdout)
      @in = in_io
      @out = out_io
    end

    def run
      until @in.eof?
        ch = @in.getc
        if ch == "\n"
          # do nothing
        elsif ch != "\\"
          @out.write ch.chr
        else
          handle_escape
        end
      end
    end

    def handle_escape
      nextc = @in.getc
      case 
      when nextc == '\\'
        @out.write "\\"
      when nextc == 'n'
        @out.write "\n"
      when nextc =~ /\h/
        otherc = @in.getc
        hex = nextc + otherc
        @out.write hex.to_i(16).chr
      else
        raise "Dont know what to do with \\ #{nextc}"
      end
    end
  end
end

