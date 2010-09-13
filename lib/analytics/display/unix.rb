class Unix < Display

  def initialize
     @line_break = "\n"
  end

  def ask_user(thing)
    say(%{<%= color('#{thing}', GREEN)%>\n})
  end

  def tell_user(thing)
    say(%{<%= color('#{thing}', YELLOW)%>\n})
  end

  def alert_user(thing)
    say(%{<%= color('#{thing}', RED)%>\n})
  end

  def get_private(thing, ast = '*')
    ask(%{<%= color('#{thing}', GREEN)%>\n}) { |pass| pass.echo="#{ast}" }
  end

end

