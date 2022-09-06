#! ruby -Ku

class String
  def get_html
    return self.gsub(/(\r\n|\r|\n)/, "<br />")
  end
end

class Array
  def get_html
    if first.class == Array
      return table_as_html
    elsif first.class == String || first.class == Fixnum
      return list_as_html
    end
  end

  def table_as_html
    str = "<table class='table table-striped table-hover'>"
    str << "\n<thead><tr>"
    self.first.each do |row|
      str << "\n<th>#{row}</th>"
    end
    str << "</tr>\n</thead>\n<tbody>"
    self[1..-1].each do |row|
      str << "\n<tr>"
      row.each do |data|
        data = data.get_html if data.class == String
        str << "<td>#{data}</td>"
      end
      str << "</tr>"
    end
    str << "</tbody>\n</table>"
    str
  end

  def list_as_html
    str = "<ul class='list-group'>"
    self.each do |data|
      data = data.get_html if data.class == String
      str << "\n<li class='list-group-item'>#{data}</li>"
    end
    str << "\n</ul>"
    str
  end
end