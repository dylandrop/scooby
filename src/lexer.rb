module Tokens
  ALL = [
    EOF = -1,

    # commands
    DEF = -2,
    EXTERN = -3,

    # primary
    IDENTIFIER = -4,
    NUMBER = -5
  ]
end

RETURN_CHARACTERS = ["\n", "\r"]

class Lexer
  attr_accessor :identifier_string, :num_val

  def initialize(io)
    @io = io
  end

  def get_token
    last_char = get_char

    while last_char == ' '
      last_char = get_char
    end

    if alpha?(last_char)
      self.identifier_string = last_char

      while alpha_numeric?(last_char = get_char)
        self.identifier_string += last_char
      end

      if identifier_string == 'def'
        return Tokens::DEF
      elsif identifier_string == 'extern'
        return Tokens::EXTERN
      else
        return Tokens::IDENTIFIER
      end
    end

    if numeric?(last_char)
      num_str = last_char
      last_char = get_char
      while numeric?(last_char)
        num_str += last_char
        last_char = get_char
      end
      self.num_val = num_str.to_f
      return Tokens::NUMBER
    end

    if last_char == '#'
      last_char = get_char

      while !RETURN_CHARACTERS.include?(last_char) && !last_char.nil?
        last_char = get_char
      end

      return get_token if !last_char.nil?
    end

    return Tokens::EOF if last_char.nil?

    this_char = last_char
    last_char = get_char
    this_char.ord
  end

  private

  def alpha?(char)
    !/[a-zA-Z]/.match(char).nil?
  end

  def alpha_numeric?(char)
    !/[a-zA-Z0-9]/.match(char).nil?
  end

  def numeric?(char)
    !/[0-9]|\./.match(char).nil?
  end

  def get_char
    @io.getc
  end
end
