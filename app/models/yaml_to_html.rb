#! ruby -Ku
require 'psych' 
require 'yaml'


class YamlToHtml
  attr_accessor :yaml, :pages, :html, :header, :body, :footer, :menus, :side_menu
  
  METHOD_NAMES = %w(table_layout list_layout)


  def initialize(yaml, title)
    @yaml = YAML.load(yaml) unless yaml.nil?
    @title = title
    @html = ""
    @header = ""
    @body = "<div class='col-xs-8'>\n"
    @footer = ""
    @menus = []
    @side_menu = ""
  end

  def to_html
    html_header
    html_body(@yaml, 1)
    html_side_menu
    html_footer

    @html = set_indent(@header + "\n" + @side_menu + "\n" + @body + "\n</div>\n" + @footer)
  end

  private
  
  def set_indent(html)
    indented_html = ""
    indent_level = 0
    indent_upper = /<html|<head|<title|<body|<table|<tr|<ul|<div/
    indent_lower = /<\/html>|<\/head>|<\/title>|<\/body>|<\/table>|<\/tr>|<\/ul>|<\/div>/
    html.each_line do |line|
      next if line == "\n"
      if indent_upper =~ line && indent_lower =~ line
        indented_html << "  " * indent_level + line
        next
      elsif indent_upper =~ line
        indented_html << "  " * indent_level + line
        indent_level += 1
      elsif indent_lower =~ line
        indent_level -= 1
        indent_level = 0 if indent_level < 0
        indented_html << "  " * indent_level + line
      else
        indented_html << "  " * indent_level + line
      end
    end
    indented_html
  end

  def html_header
    @header = <<-EOS
<div class='container' style="width: 100%">
<div class='jumbotron'>
<h1>#{@title}</h1>
</div>
      EOS
  end

  def html_body(yaml, level)
    convert_yaml = [Hash, Array].include?(yaml.class) ? yaml : yaml.to_s
    convert_yaml.yaml_each do |key, value|
      if METHOD_NAMES.include?(key.to_s)
        @body << self.send(key.to_s, value)
      elsif value.class == Hash
        @body << section(key, level)
        @body << "\n<div class='container-fluid'>"
        html_body(value, level + 1)
        @body << "\n</div>"
      elsif value.class == Array
        @body << section(key, level)
        value.each do |v|
          html_body(v, level + 1)
        end
      else
        @body << section(key, level, value.to_s)
      end
    end
  end

  def html_footer
    @footer = <<-EOS
\n<div class='col-xs-1'></div>
</div>
    EOS
  end

  def html_side_menu
    @side_menu << "\n<div class='col-xs-3' id='side_menu'>\n"
    @side_menu << "\n<ul>\n"
    @menus.each_with_index do |menu, i|
      if menu[0] == 1 && (@menus.size != i + 1 && @menus[i + 1][0] == 2)
        @side_menu << "<li>#{menu[1]}</li>\n"
        @side_menu << "\n<ul>\n"
      else
        @side_menu << "<li>#{menu[1]}</li>\n"
      end
      if menu[0] == 2 && (@menus.size == i + 1 || @menus[i + 1][0] == 1)
        @side_menu << "</ul>\n"
      end
    end
    @side_menu << "</ul>\n</div>\n"
  end

  def section(yaml_key, level, value = nil)
    if level == 2 || level == 1
      id = @menus.size
      @menus << [level, "<a href=\'#h-#{id}\'>#{yaml_key}</a>"]
      if value
        return "\n<h#{level} id=\'h-#{id}\'>#{yaml_key}</h#{level}> -> #{value}"
      else
        return "\n<h#{level} id=\'h-#{id}\'>#{yaml_key}</h#{level}>"
      end
    else
      if value
        return "\n<h#{level}>#{yaml_key}: #{value}</h#{level}>"
      else
        return "\n<h#{level}>#{yaml_key}</h#{level}>"
      end
    end
  end
  
  def table_layout(value)
    raise unless value.class == Array
    ret = "\n<table class=\"table table-striped table-hover\">\n"
    value.each_with_index do |row, i|
      raise unless row.class == Array
      if i == 0
        ret << "<tr>\n<th>" + row.join("</th>\n<th>") + "</th>\n</tr>\n"
      else
        ret << "<tr>\n<td>" + row.join("</td>\n<td>") + "</td>\n</tr>\n"
      end
    end
    ret << "</table>\n"
    ret
  end
  
  def list_layout(value)
    raise unless value.class == Array
    ret = "\n<ul>\n"
    value.each do |v|
      if v.class == Hash && v.keys.first.to_s == "list_layout"
        ret << list_layout(v["list_layout"])
      elsif v.class != Hash
        ret << "<li>#{v}</li>\n"
      end
    end
    ret << "</ul>\n"
  end
end


class String
  def yaml_each
    yield(nil, self)
  end
end

class Array
  
  def yaml_each
    self.each_with_index do |value, i|
      yield(i, value)
    end
  end
end

class Hash
  def yaml_each
    self.each do |k, v|
      yield(k, v)
    end
  end
end