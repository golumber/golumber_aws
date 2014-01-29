module ProductsHelper
	def addUpdateProductsOnChange
		javascript_tag("addUpdateProductsOnChange()")
	end
	
# Displays a table containing the specified products' data in the specified units
# @param products: a relation containing all of the products to be displayed
#	    if products is empty, only the column headers will be displayed
# @param imperial: a boolean value specifying the units to display
#     true:  imperial will be displayed
#     false: metric will be displayed
# @param activityColumn: true if a column should be included to show whether the items are active
#	@param search: true if this is the search table, false if it is on an inventory page
#	    the search page includes a column for the product's company and that company's country
#	    the search page also allows you to scroll through the results 
	def productTable(products, imperial = true, activityColumn = false, search = false)
		render 'product_table', {:products => products, :imperial => imperial, :activityColumn => activityColumn, :search => search}
	end
	
# Displays a header row for a product table using the specified units
# @param imperial: a boolean value specifying the units to display
#     true:  imperial will be displayed
#     false: metric will be displayed
# @param activityColumn: true if a column should be included to show whether the items are active
	def productTableHeaders(imperial = true, activityColumn = false, search = false)
    render 'product_table_headers', {:imperial => imperial, :activityColumn => activityColumn, :search => search}
	end
	
# Displays a table row containing product's data in the same order as product_table_headers
# @param product: the product to be displayed
# @param imperial: a boolean value specifying the units to display
#     true: imperial will be displayed
#     false: metric will be displayed
# @param activityColumn: true if a column should be included to show whether the items are active
	def productTableRow(product, imperial = true, activityColumn = false, search = false)
    render 'product_table_row', {:product => product, :imperial => imperial, :activityColumn => activityColumn, :search => search}
	end
end
