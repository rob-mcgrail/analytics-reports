class Array
  
  def average
   
    @total = 0
        
    self.each do |thing|
      @total += thing.to_f
    end
    
    average = @total.to_f/self.size.to_f
    
    average
  end

  def sum
    self.inject {|sum, x| x = x.to_f; sum + x }
  end
  
  def capture(string) #this idea is sound, but needs a different implimentation
                      #you could use this from within the format classes?
    
    self << string
    if !defined? $display
      $display = Display.new
    end
    $display.print(thing)
  end

end