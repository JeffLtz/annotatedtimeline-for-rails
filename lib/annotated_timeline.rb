module AnnotatedTimeline 

  def annotated_timeline(daily_counts_by_type, width = 750, height = 300, element = 'graph', options = {}, annotations = {})
  
      html = "<script type=\"text/javascript\" src=\"http://www.google.com/jsapi\"></script>\n<script type=\"text/javascript\"> \n"
      html += "google.load(\"visualization\", \"1\", {packages:[\"annotatedtimeline\"]}); \n"  
      html += "google.setOnLoadCallback(drawChart);"    
      html += "function drawChart(){"  
    	html += "var data = new google.visualization.DataTable(); \n"
  		html += google_graph_data(daily_counts_by_type, annotations)
  		html += "var chart = new google.visualization.AnnotatedTimeLine($(\'#{element}\')); \n"
  		html += "chart.draw(data"   
		

  		  if options[:zoomEndTime]
  		    options[:zoomEndTime] = "new Date(#{options[:zoomEndTime].year}, #{options[:zoomEndTime].month-1}, #{options[:zoomEndTime].day})"
  	    end
  	    if options[:zoomStartTime]
  	      options[:zoomStartTime] = "new Date(#{options[:zoomStartTime].year}, #{options[:zoomStartTime].month-1}, #{options[:zoomStartTime].day})"
        end
        if options[:colors]
          options[:colors] = "#{options[:colors].inspect}"
        end
  		  array = options.map{|key,val| key.to_s + ": " + val.to_s}
  		  html += (", {" + array.join(", ") + "}") unless array.empty?
		
  		html += "); } \n"		
  		html += "</script>"
  		html +=	"<div id=\"#{element}\" style=\"width: #{width}px\; height: #{height}px\;\"></div>"
  
  end

  def google_graph_data(daily_counts_by_type, annotations)
    length = daily_counts_by_type.values.size
    column_index = {}
    num = 0
    html = ""
  
    daily_counts_by_type.each_key{|key| key = key.at_midnight}
    
    
      annotations.each_key{|key| key = key.at_midnight}
    
    
    #set up columns and assign them each an index
    html += "data.addColumn('date', 'Date'); \n"  
    daily_counts_by_type.values.inject(&:merge).stringify_keys.keys.sort.each do |type,count|
  		html+="data.addColumn('number', '#{type.to_s.titleize}');\n"
  		column_index[num+=1] = type.to_sym
  		
  		if annotations.values.inject(&:merge).stringify_keys.keys.include?(type + "_title")
  		  html += "data.addColumn(\'string\', \'#{type.to_s.titleize} Title\');\n"
  		  column_index[num+=1] = (type + "_title").to_sym
		  end
  	
  	  if annotations.values.inject(&:merge).stringify_keys.keys.include?(type + "_text")
  		  html += "date.addColumn(\'string\', \'#{type.to_s.titleize} Text\');\n"
  		  column_index[num+=1] = (type + "_text").to_sym
  		end
  		
  	end    
    
    html+="data.addRows(#{length});\n"
    
    daily_counts_by_type.merge!(annotations)
    
    p "%%%%"
    p daily_counts_by_type.inspect
    
    
    html+=add_data_points(daily_counts_by_type, column_index)
    html	
  end

  def add_data_points(daily_counts_by_type, column_index)
    html = ""
    #first sort everything by date
    daily_counts_by_type.sort.each_with_index do |obj, index|
      date, type_and_count = obj
  		date_params = "#{date.year}, #{date.month-1}, #{date.day}"
  		html+="data.setValue(#{index}, 0, new Date(#{date_params}));\n"
    
      #now go through column types in the order saved in column_index
      column_index.each do |col_num, type|
        type_and_count[type] && html+="data.setValue(#{index}, #{col_num}, #{type_and_count[type]});\n"
      end
      
    end
  	html
  end

end