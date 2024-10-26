module ApplicationHelper
  def restaurant_item_path(restaurant, item)
    send("restaurant_#{item.class.name.downcase}_path", restaurant, item)
  end

  def restaurant_items_path(item, restaurant)
    send("restaurant_#{item.class.name.pluralize.downcase}_path", restaurant)
  end
end
