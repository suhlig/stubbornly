require 'pathname'

class ReadmeParser
  def initialize(file)
    @file = Pathname(file)
  end

  def fenced_code_blocks
    lines = []
    blocks = []
    in_fcb = false

    @file.readlines.each do |line|
      lines << line if in_fcb && !boundary?(line)

      if in_fcb && boundary?(line)
        in_fcb = false
        blocks << lines.join
        lines = []
      end

      in_fcb = true if !in_fcb && boundary?(line)
    end

    blocks
  end

  private

  def boundary?(line)
    line.start_with?('```')
  end
end
