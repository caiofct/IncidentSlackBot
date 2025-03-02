module ApplicationHelper
  def toggle_direction(direction)
    direction == "asc" ? "desc" : "asc"
  end

  def sort_header_class(sort)
    if params[:sort] == sort
      "bg-gray-200 text-gray-900 group-hover:bg-gray-300"
    else
      "invisible text-gray-400 group-hover:visible group-focus:visible"
    end
  end

  def sort_icon_class(sort)
    params[:sort] == sort && params[:direction] == "asc" ? "rotate-180" : ""
  end
end
