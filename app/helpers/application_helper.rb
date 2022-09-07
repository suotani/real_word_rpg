module ApplicationHelper
  def current_user_id
    session[:user_id]
  end

  def full_title(page_title)
    base_title = "Xnotepad"
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def level_class(level)
    return "primary" if level.nil?
    ["danger", "warning", "primary", "success", "default"][level]
  end

  def level_label(level)
    return ManagedHtml::LEVEL[2] if level.nil?
    ManagedHtml::LEVEL[level]
  end
  
  def search_params(p)
    { level: p[:level], title: p[:title], tag: p[:tag], sort: p[:sort] }
  end
  
  def sort_class(p, key)
    if p[:sort] == nil || p[:sort].to_s != key.to_s
      return "btn-default"
    elsif p[:sort].to_s == key.to_s
      return "btn-primary"
    end
  end

  def sort_class_default(p, key)
    return "btn-primary" if p[:sort].nil?
    sort_class(p, key)
  end
  
  def order_class(p)
    if p[:order] == nil || p[:order].to_s == "asc"
      return "btn-default"
    else
      return "btn-primary"
    end
  end
end
