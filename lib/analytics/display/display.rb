class Display
  #Display includes methods for displaying results
  attr_reader :line_break

  def initialize(line_break)

    @line_break = line_break
  end

  def break
    puts @line_break
  end

  def print(thing)
    puts thing
  end

  def ask_user(thing)
    puts thing
  end

  def tell_user(thing)
    puts thing
  end

  def alert_user(thing)
    puts thing
  end

  def get_private(thing, ast = '*')
    raise "I am supposed to be obscuring a password, but you need a child of me to do this."
  end

  def <<(thing)
    puts thing
  end
end

