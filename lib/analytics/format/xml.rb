class XML < Format
  attr_accessor :x


  def initialize
    if !defined? $collector
      $display << "The collector is not defined. I am instantiating it now..."
      $collector = OpenStruct.new #this will be initialized by whichever object gets there first
    end

    #set values for arrows

    @green_up = "green_up"
    @green_down = "green_down"
    @red_up = "red_up"
    @red_down = "red_down"
    @grey_up = "grey_up"
    @grey_down = "grey_down"
    @equals = "equals"

    @collector = String.new #this is the local collector
                            #to 'go global', run self.finish

    @x = Builder::XmlMarkup.new(:target => @collector, :indent => 2)

    @x.instruct!

  end


#details (a comment about the report)


  def header(page_title = "Enter a title!", page_category = "Enter a category!") #pass you title and category in at this point...

    #puts together the whole header sections

    @x.comment!("header!")

    @x.header {
      self.title(page_title, page_category)
      self.date_section
    }


    # <!-- header! -->
    # <header>
    #   <title_section>
    #     <category>Enter a category!</category>
    #     <title>Enter a title!</title>
    #   </title_section>
    #   <dates>
    #     <date_range>Reporting period 09/01/10 - 09/03/10</date_range>
    #     <date_range>Reporting period 08/11/09 - 08/01/10</date_range>
    #     <date_range>Reporting period 08/07/09 - 08/01/10</date_range>
    #   </dates>
    # </header>
  end



  def title(page_title = "Enter a title!", page_category = "Enter a category")

    #prints title and category

    @x.title_section {
      @x.category("#{page_category}")
      @x.title("#{page_title}")
    }
  end

  def date_section

    #prints the dates

    @x.dates {
      @x.date_range("Reporting period #{$periods.start_date_reporting.strftime("%d/%m/%y")} - #{$periods.end_date_reporting.strftime("%d/%m/%y")}")
      @x.date_range("Previous period #{$periods.start_date_previous.strftime("%d/%m/%y")} - #{$periods.end_date_previous.strftime("%d/%m/%y")}")
      @x.date_range("Baseline period #{$periods.start_date_baseline.strftime("%d/%m/%y")} - #{$periods.end_date_baseline.strftime("%d/%m/%y")}")
    }

  end


  def main_graph(struct)

    #makes the big three line graph

    #intended to make a lingraph with to flat averages
    #but could make a genuine three line graph if passed right

    #recieves ostruct containing .title (string)
    #                            .key (array of strings)
    #                            .data (an array of arrays - each array contains the data values)

    @x.linegraph{
      @x.title(struct.title)
      @x.data{
        i = 0
        struct.data.each do |data|

          @x.line(  "id"=>"#{struct.keys[i]}"  ){
           data.each do |x|
              @x.value(x)
          end
          }
          i+=1
        end
      }
    }

#    <linegraph>
#      <title>Visits</title>
#      <data>
#          <value>404</value>
#          <value>175</value>
#          <value>259</value>
#          <value>399</value>
#          <value>437</value>
#        </line>
#        <line id="Average">
#          <value>307.6</value>
#          <value>307.6</value>
#          <value>307.6</value>
#          <value>307.6</value>
#          <value>307.6</value>
#        </line>
#        <line id="Baseline">
#          <value>228.983783783784</value>
#          <value>228.983783783784</value>
#          <value>228.983783783784</value>
#          <value>228.983783783784</value>
#          <value>228.983783783784</value>
#        </line>
#      </data>
#    </linegraph>

  end

  def bar_series(struct)

    #prints a bargraph for a single series
    #expects an ostruct containing:

    # title, series (an array of values)

    @x.series_graph{
      @x.title(struct.title)
      @x.data{
        @x.series{
          struct.data.each do |data|
            data.each do |x|
              @x.value(x)
            end
          end
        }
      }
    }

    # <series_graph>
    #   <title>Traffic by hour</title>
    #   <data>
    #     <series>
    #       <value>585</value>
    #       <value>606</value>
    #       <value>674</value>
    #       <value>647</value>
    #     </series>
    #   </data>
    # </series_graph>

  end

  def table(struct)

    #prints a table with title and headings
    #expects a ostruct with :title, :header (an array of heading titles)
    #and :rows, an array of arrays of data.

    if struct.title != nil
      @x.title(struct.title)
    end
    @x.table( "id" => struct.table_id ){
      if struct.header != nil
        @x.tr{
          struct.header.each do |thing|
            @x.th(thing)
          end
        }
      end
      struct.rows.each do |thing|
        @x.tr{
          thing.each do |data|
            @x.td(data)
          end
        }
      end
    }


    # <title>Most popular content</title>
    # <table id="popular">
    #   <tr>
    #     <th>Page</th>
    #     <th>Pageviews</th>
    #     <th>Avg session</th>
    #   </tr>
    #   <tr>
    #     <td>/</td>
    #     <td>4393</td>
    #     <td>00:24</td>
    #   </tr>
    #   <tr>
    #     <td>/themes/biotech_at_home/enzymes_in_washing_powders</td>
    #     <td>3067</td>
    #     <td>00:04</td>
    #   </tr>
    #   <tr>
    #     <td>/themes/biotech_at_home/enzymes_in_washing_powders/</td>
    #     <td>3030</td>
    #     <td>04:11</td>
    #   </tr>
    #   <tr>
    #     <td>/content/advancedsearch/</td>
    #     <td>1494</td>
    #     <td>00:34</td>
    #   </tr>
    #   <tr>
    #     <td>/themes/biotech_therapies/stem_cells</td>
    #     <td>797</td>
    #     <td>00:04</td>
    #   </tr>
    # </table>


  end

  def block_full(struct)

    #prints a value with previous and baseline changes
    #expects an ostruct containing:

    #title, r, p_change, p_value, p_arrow, b_change, b_value, b_arrow

    @x.block_item {
      @x.main {
        @x.value_title(struct.title)
        @x.value(struct.r)
      }
      @x.previous {
        @x.change(struct.p_change)
        @x.arrow(struct.p_arrow)
        @x.value(struct.p_value)
      }
      @x.baseline {
        @x.change(struct.b_change)
        @x.arrow(struct.b_arrow)
        @x.value(struct.b_value)
      }
    }

    # <block_full>
    #  <main>
    #   <value_title>Visits</value_title>
    #   <value>18456</value>
    #  </main>
    #  <previous>
    #   <change>28%</change>
    #   <arrow>green_up</arrow>
    #   <value>14422</value>
    #  </previous>
    #  <baseline>
    #   <change>31%</change>
    #   <arrow>green_up</arrow>
    #   <value>14072.0</value>
    #  </baseline>
    # </block_full>
  end





  def comparison(array)

    #prints a bar divided between two proportions
    #expects an array with 4, and only 4, values

    if array.length != 3
      raise "Passed the XML.relative method an array that is the wrong length. It should be three."
    end

    @x.comparison_bar_graph {
      @x.title("#{array[0]}" + "/" + "#{array[1]}")
      @x.bar {
        @x.value("#{array[2]}")
        @x.value("#{array[3]}")
      }
    }

    # <comparison_bar_graph>
    #   <title>New / Returning</title>
    #   <bar>
    #     <value>83</value>
    #     <value>17</value>
    #   </bar>
    # </comparison_bar_graph>
  end

#bar

  def finish
    $display.tell_user "Putting xml output in to $collector. Access with $collector.xml"
    $collector.xml = @collector
  end




end

