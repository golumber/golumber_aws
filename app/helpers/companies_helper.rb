module CompaniesHelper
# returns the company's name linked to their profile   
  def nameLink
    link_to name, products_path(:company => id), :method => "get"
  end
end
