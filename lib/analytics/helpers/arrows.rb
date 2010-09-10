module Arrows
 # a mixin for adding arrow functions to classes

  def arrow(change)
    # sets orientation and color of arrows for results
    # each data class method is expected to have bool values for
    # up_is_nothing? (not good or bad, so grey) and up_is_good? (whether it is green or red)
    # to see how this works check the test/crunch script

    change = change.to_f

    if change == 0
      @arrow = $format.equals
      return @arrow
    end

    if change > 0
      if self.up_is_nothing?
        @arrow = $format.grey_up
        return @arrow
      end
      if self.up_is_good?
        @arrow = $format.green_up
      else
        @arrow = $format.red_up
      end

    else
      if self.up_is_nothing?
        @arrow = $format.grey_down
        return @arrow
      end
      if self.up_is_good?
        @arrow = $format.red_down
      else
        @arrow = $format.green_down
      end
    end
  end

end

