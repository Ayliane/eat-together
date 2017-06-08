module ApplicationHelper
  def food_types
    RestaurantRemote::CATEGORIES.map do |key, value|
      key.capitalize
    end
  end


  def illustration_for(resto)
    if resto.logo_url.present?
      image_tag resto.logo_url
    else
      content_tag('div', class: 'logo-placeholder') do
        content_tag('p', class: 'logo-text') do
          resto.name
        end
      end
    end
  end
end
