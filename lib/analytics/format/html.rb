class HTML
  include Charts
  attr_accessor :x
  
  def initialize(stylesheet = nil, logo = nil)
    if !defined? $collector
      $display << "The collector is not defined. I am instantiating it now..."
      $collector = OpenStruct.new #this will be initialized by whichever object gets there first
      $collector.output = String.new #this is so there is always an easy compatible print method in report classes
      
    end
    
    @collector = String.new #this is the local collector
                            #to 'go global', run self.finish

    @x = Builder::XmlMarkup.new(:target => @collector, :indent => 2)

    # @x.instruct! #apparently this is invalid...
    
    # set name for stylesheet (passed in as argument from bin/)
    
    @stylesheet = stylesheet
    @logo = logo
    
    #set values for arrows
    
    #
    # for the fop formatted report, these are copied from /assets/arrows to the /output/x folder
    #
    # the method that does this self.copy_assets
    #

    @green_up = 'up_green.png'
    @green_down = 'down_green.png'
    @red_up = 'up_red.png'
    @red_down = 'down_red.png'
    @grey_up = 'up_grey.png'
    @grey_down = 'down_grey.png'
    @equals = 'equals.png'
    
    @logo = "logo.png" #defining the logo file, if there is one
    
  end
  
  def header(page_title = "Enter a title!", page_category = "Enter a category!") #pass you title and category in at this point...
    
    #puts together the whole header sections

    @x.comment!("header!")

    @x.div("id"=>"header"){
      self.title(page_title, page_category)
      self.date_section
      @x.div("id"=>"logo"){
        @x.img("src"=>@logo)
      }
    }


  end



  def title(page_title = "Enter a title!", page_category = "Enter a category")

    #prints title and category

    @x.div("id"=>"title"){
      @x.h1("#{page_title}")
      @x.span("id"=>"category"){
        @x.p("#{page_category}")
      }
    }
    
  end

  def date_section

    #prints the dates

    @x.div("id"=>"dates"){
      @x.p("id"=>"date"){
        @x.span("Reporting period #{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}", "id"=>"date_value")
      }
      @x.p("id"=>"date"){
        @x.span("Previous period #{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}", "id"=>"date_value")
      }
      @x.p("id"=>"date"){
        @x.span("Baseline period #{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}", "id"=>"date_value")
      }
    }

  end

  def table(struct)

    #prints a table with title and headings
    #expects a ostruct with :title, :header (an array of heading titles)
    #and :rows, an array of arrays of data.

    
    @x.tag!(struct.title){
      struct.rows.each do |row|
        i = 1
        n = row.length
        @x.tag!(struct.header[0]){
          @x.tag!("#{struct.header[0]}_name", row[0])
          while n > 1
            @x.tag!(struct.header[i], row[i])
            i+=1
            n-=1
          end
        }
      end
      }  
  end

  def block_full(struct)

    #prints a value with previous and baseline changes
    #expects an ostruct containing:

    #title, r, p_change, p_value, p_arrow, b_change, b_value, b_arrow

    @x.tag!(struct.title + "_section") {
      @x.reporting {
        @x.tag!(struct.title, struct.r)
      }
      @x.previous {
        @x.tag!(struct.title, struct.p_value)
        @x.tag!("#{struct.title}" + "_change", struct.p_change)
        if struct.p_arrow =~ /png|jpg|bmp/
          @x.tag!("#{struct.title}" + "_arrow"){
            @x.external_graphic(struct.p_arrow)
          }
        else
          @x.tag!("#{struct.title}" + "_arrow", struct.p_arrow)
        end
      }
      @x.baseline {
        @x.tag!(struct.title, struct.b_value)
        @x.tag!("#{struct.title}" + "_change", struct.b_change)
        if struct.b_arrow =~ /png|jpg|bmp/
          @x.tag!("#{struct.title}" + "_arrow"){
            @x.external_graphic(struct.b_arrow)
          }
        else
          @x.tag!("#{struct.title}" + "_arrow", struct.b_arrow)
        end      }
    }

  end

  def bar_series(struct)
        #gets a url for a bargraph from the google charts api
        #expects an ostruct containing:

        # title, series (an array of values)

    src = Charts.bar_series(struct.title, struct.data[0])

    @x.series_graph{
      @x.external_graphic(src)
    }
  end
  
  def comparison(array)

    #prints a bar divided between two proportions
    #expects an array with 3, and only 3, values

    if array.length != 3
      raise "Passed the Fop.relative method an array that is the wrong length. It should be three."
    end

    #make changes to the values so one is 100, one is itself

    src = Charts.comparison("#{array[0]}" + " / " + "#{array[1]}", array[2], array[0], array[1])
    
    @x.comparison_bar{
      @x.external_graphic(src)
    }
  end
  
  def labelled_series(struct)
    
    #
    # gets chart class to return a png of the depth or length of visit style bar graph
    #
    # expects a :title, :data (array), :keys (array of strings)
    #
  
    if struct.data[0].length != struct.keys.length
      raise "Passed the Fop.labelled series a different ammount of values and keys..."
    end
  
    src = Charts.labelled_series(struct.title, struct.data[0], struct.keys)
  
    @x.labelled_series{
      @x.external_graphic(src)
    }
  end

  def main_graph(struct)

    #makes the big three line graph

    #intended to make a lingraph with to flat averages
    #but could make a genuine three line graph if passed right
    
    src = Charts.large_linegraph(struct.title, struct.data[0], struct.data[1], struct.data[2], struct.keys[0], struct.keys[1], struct.keys[2])
    
    @x.main_graph{
      @x.external_graphic(src)
    }
  end
  
  def wash(xml)
    xml.gsub!(/((\<|\<\/)([a-z|\w|\s|_])+)\//, "\\1-")  # washing forward slashes from tags

    xml.gsub!("&amp;", "&")     # washing escapes!

    xml.gsub!(/<\/?[^>]*>/) do |match|
      match.downcase!
      match.gsub(" ", "_")
    end
        
   xml
  end

  
  def finish
    # self.copy_assets
    $display.tell_user "Putting html output in to $collector. Access with $collector.html"
    #$collector.html = self.wash @collector             # wash out caps, spaces and slashes from tags, in xml.rb
    
    $collector.html = @collector
    
    $collector.output << $collector.html               # for compatibility with other classes use of $collector
  end
  
  def copy_assets
    
    #
    #copies the arrow image files to the report folder in /output
    #
    
    arrows = [@green_up, @green_down, @red_up, @red_down, @grey_up, @grey_down, @equals]
    
    arrows.each do |file|
      FileUtils.cp(File.expand_path(File.dirname(__FILE__) + "/../../../assets/arrows/#{file}"), $path + "/")
    end
    
    #copies xsl-fo file
    if @stylesheet != nil
      FileUtils.cp(File.expand_path(File.dirname(__FILE__) + "/xsl/#{@stylesheet}"), $path + "/")
    end
    
    #copies cwa logo
    if @logo != nil
      if @logo == "cwa"
        FileUtils.cp(File.expand_path(File.dirname(__FILE__) + "/../../../assets/logos/cwa_logo.png"), $path + "/")
      end
    end
  end
  
end

