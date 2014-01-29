# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@initializeProductForm = ->
	addLengthInputChanged()
	addUnitChanged()
	addRandomWidthChanged()
	$("#product_species_id").focus()

@addUpdateProductsOnChange = ->
	$('.update_products').change(updateProducts)
	updateProducts()

@updateProducts = ->
	imperial = $('#unit_imperial').is(':checked')
	display = $('input[name=view_products]:checked').val()
	$.get('products/table', {imperial: imperial, display: display})

@addUnitChanged = ->
	$("[name='unit']").change(unitChanged)

@initializeSearch = ->
	$("[name='unit']").change(searchUnitChanged)
	$("#species").change(speciesChanged)
	$("#thickness").change(thicknessChanged)
	$("#width").change(widthChanged)
	$("#grade").change(gradeChanged)

@searchUnitChanged = ->
	imperial = $('#unit_imperial').is(':checked')
	species = $('#species').val()
	thickness = $('#thickness').val()
	thickness_type = $('#thickness').find(':selected').data('type')
	width = $('#width').val()
	width_type = $('#width').find(':selected').data('type')
	grade = $('#grade').val()
	if grade != "Grade"
		$.get('products/table', {search: true, imperial: imperial, species: species, thickness: thickness, thickness_type: thickness_type, width: width, width_type: width_type, grade: grade})	
	if species == "Species"
		$.get('products/update_search_selects')
	else
		$.get('products/update_search_selects', {imperial: imperial, species: species})

@speciesChanged = ->
	imperial = $('#unit_imperial').is(':checked')
	species = $('#species').val()
	$.get('products/update_search_selects', {imperial: imperial, species: species})

@thicknessChanged = ->
	imperial = $('#unit_imperial').is(':checked')
	species = $('#species').val()
	thickness = $('#thickness').val()
	thickness_type = $('#thickness').find(':selected').data('type')
	$.get('products/update_search_selects', {imperial: imperial, species: species, thickness: thickness, thickness_type: thickness_type})

@widthChanged = ->
	imperial = $('#unit_imperial').is(':checked')
	species = $('#species').val()
	thickness = $('#thickness').val()
	thickness_type = $('#thickness').find(':selected').data('type')
	width = $('#width').val()
	width_type = $('#width').find(':selected').data('type')
	$.get('products/update_search_selects', {imperial: imperial, species: species, thickness: thickness, thickness_type: thickness_type, width: width, width_type: width_type})

@gradeChanged = ->
	imperial = $('#unit_imperial').is(':checked')
	species = $('#species').val()
	thickness = $('#thickness').val()
	thickness_type = $('#thickness').find(':selected').data('type')
	width = $('#width').val()
	width_type = $('#width').find(':selected').data('type')
	grade = $('#grade').val()
	$.get('products/table', {search: true, imperial: imperial, species: species, thickness: thickness, thickness_type: thickness_type, width: width, width_type: width_type, grade: grade})

@unitChanged = ->
	switch ($('input[name=unit]:checked').val())
		when "metric"
			$(".metric").show()
			$(".imperial").hide()
		when "imperial"
			$(".metric").hide()
			$(".imperial").show()

@addLengthInputChanged = ->
	$("[name='length_input']").change(lengthInputChanged)

@lengthInputChanged = ->
	switch ($('input[name=length_input]:checked').val())
		when "single"
			$("#product_length_imperial_lower").visible()
			$("#product_length_imperial_lower").readOnly = false
			$("#product_length_metric_lower").visible()
			$("#product_length_metric_lower").readOnly = false
			$("#product_length_imperial_upper").invisible()
			$("#product_length_imperial_upper").readOnly = true
			$("#product_length_metric_upper").invisible()
			$("#product_length_metric_upper").readOnly = true
		when "ranged"
			$("#product_length_imperial_lower").visible()
			$("#product_length_imperial_lower").readOnly = false
			$("#product_length_metric_lower").visible()
			$("#product_length_metric_lower").readOnly = false
			$("#product_length_imperial_upper").visible()
			$("#product_length_imperial_upper").readOnly = false
			$("#product_length_metric_upper").visible()
			$("#product_length_metric_upper").readOnly = false
		else
			$("#product_length_imperial_lower").invisible()
			$("#product_length_imperial_lower").readOnly = true
			$("#product_length_metric_lower").invisible()
			$("#product_length_metric_lower").readOnly = true
			$("#product_length_imperial_upper").invisible()
			$("#product_length_imperial_upper").readOnly = true
			$("#product_length_metric_upper").invisible()
			$("#product_length_metric_upper").readOnly = true

@addRandomWidthChanged = ->
	$("#random_width").change(randomWidthChanged)
	randomWidthChanged()

@randomWidthChanged = ->
	if ($('#random_width').prop('checked'))
		$('#product_width_imperial').prop('disabled', true)
		$('#product_width_actual').prop('disabled', true)
		$('#product_width_metric').prop('disabled', true)
	else
		$('#product_width_imperial').prop('disabled', false)
		$('#product_width_actual').prop('disabled', false)
		$('#product_width_metric').prop('disabled', false)		

@ClearExtraFields = ->
	if $('input[name=unit]:checked').val() == "imperial"
		$('.metricField').value = null
		if $('input[name=length_input]:checked').val() == "single"
			$('#length_imperial_upper').val(null)
		else if $('input[name=length_input]:checked').val() == "random"
			$('#length_imperial_upper').val(null)
			$('#length_imperial_lower').val(0)
	else
		$('.imperialField').value = null
		if $('input[name=length_input]:checked').val() == "single"
			$('#length_metric_upper').val(null)
		else if $('input[name=length_input]:checked').val() == "random"
			$('#length_metric_upper').val(null)
			$('#length_metric_lower').val(0)

jQuery.fn.visible = ->
	@css "visibility", "visible"

jQuery.fn.invisible = ->
	@css "visibility", "hidden"

jQuery.fn.visibilityToggle = ->
	@css "visibility", (i, visibility) ->
		(if (visibility is "visible") then "hidden" else "visible")
