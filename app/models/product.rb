class Product < ActiveRecord::Base
  attr_accessible :details, :is_active, :grade_id, :company_id, :species_id, :thickness_metric,
                  :thickness_imperial, :thickness_actual, :width_metric, :width_imperial,
                  :width_actual, :length_metric_lower, :length_metric_upper, :length_imperial_lower,
                  :length_imperial_upper, :board_feet, :cubic_meters, :primary_photo_id, :photos_attributes, :region
  belongs_to :company
  belongs_to :grade
  belongs_to :species
  belongs_to :primary_photo, :class_name => 'Photo'
  has_many :photos, :as => :imageable, :dependent => :destroy
  
  include ActionView::Helpers::TagHelper
  
  accepts_nested_attributes_for :photos, :allow_destroy => true,
              :reject_if => proc {|attributes| attributes['filename'].blank? && attributes['filename_cache'].blank?}

  validates :company_id, :grade_id, :species_id, :presence => true
  
  # ***Not sure we need precision on these fields as they are rounded before they are stored in the db.
  # Same as the precision in the migration stored in the database, plus a character for the decimal
  #validates :thickness_metric_gross, :thickness_metric_net,:thickness_imperial_gross,
  #          :thickness_imperial_net, :length => { :maximum => 6 }
  #validates :width_metric_gross, :width_metric_net, :width_imperial_gross,
  #         :width_imperial_net, :length => { :maximum => 6 }
  #validates :board_feet, :length => { :maximum => 7 }
  #validates :cubic_meters, :length => { :maximum => 8 }
  #validates :length_metric_upper, :length_metric_lower, :length => { :maximum => 4 }
  #validates :length_imperial_upper, :length_imperial_lower, :length => { :maximum => 5 }
  #validates :details, :length => { :maximum => 250 }
    
  validates :thickness_metric, :thickness_actual, :board_feet, :cubic_meters,
            :numericality => { :greater_than_or_equal_to => 0 }
  after_initialize :init 
  
  def init
    self.is_active = true if self.is_active.nil? unless attributes["is_active"].nil?
  end

  # returns details or a short version of details with full details on mouse hover
  # @return: details if it is shorter than 18 chars
  # @return: otherwise, the first 15 chars of details followed by an ellipsis
  #          along with a span including the 
  def shortDetails
    if details.length > 18
      content_tag(:div, details[0,15] + '...', :title => details)
    else
      content_tag(:div, details)
    end
  end

  # returns the thickness of the product in the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def thickness(imperial = true)
    if(imperial)
      # if thickness_imperial.blank?
      returnValue = thickness_actual.to_s
      # else
        # returnValue = thickness_imperial.to_s
      # end
    else
      returnValue = thickness_metric.to_s
    end

    #For truncating value to 3 decimals
    returnValue = returnValue.to_f                
    returnValue = returnValue.round(3)
    return returnValue.to_s
  end

  # returns the width of the product in the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def width(imperial = true)
    if(imperial)
      # if width_imperial.blank?
      returnValue = width_actual
      # else
        # returnValue = width_imperial
      # end
    else
      returnValue = width_metric
    end
    if returnValue.to_f == 0
      return 'Random'
    else
      #For truncating value to 3 decimals
      returnValue = returnValue.to_f
      returnValue = returnValue.round(3)
      return returnValue.to_s
    end
  end

  # returns the length of the product in the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def length(imperial = true)
    if imperial
      length_lower = length_imperial_lower
      length_upper = length_imperial_upper
    else
      length_lower = length_metric_lower
      length_upper = length_metric_upper
    end
    if length_upper.nil?
      returnValue = length_lower
    else
      returnValue = length_lower.to_s + '-' + length_upper.to_s
    end
    if returnValue.to_f == 0
      return 'Random'
    else
      returnValue = returnValue.to_f
      returnValue = returnValue.round(3)
      return returnValue.to_s
    end
  end

  # returns the volume of the product in the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def volume(imperial = true)
    if imperial
      returnValue = board_feet.to_s
    else
      returnValue = cubic_meters.to_s
    end
    return returnValue
  end

  # returns the thickness header for the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def self.thickness_header(imperial = true)
    if imperial
      return "Thickness (in)"
    else
      return "Thickness(mm)"
    end
  end

  
  # returns the width header for the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def self.width_header(imperial = true)
    if(imperial)
      return "Width(in)"
    else
      return "Width(mm)"
    end
  end
  
  # returns the length header for the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def self.length_header(imperial = true)
    if imperial
      return "Length(ft)"
    else
      return "Length(m)"
    end
  end
  
  # returns the volume header for the specified units as a string
  # @param: imperial - true if imperial should be returned, otherwise false
  def self.volume_header(imperial = true)
    if imperial
      return "Volume (BF)"
    else
      return "Volume (CM)"
    end
  end


  # returns html for the thumbnail for this product's photo
  # @return: a tag containing the thumbnail for this product
  # @return: nothing if there is no photo
  def primary_photo_thumbnail
    if !primary_photo.nil?
      primary_photo.thumbnail_tag(:small_thumbnail)
    else
      Photo.default_thumbnail
    end      
  end

  # Given a species_id, this returns the thickness values of active products 
  # of that species.      
  def self.available_thickness(species_id, measurement)
    if measurement == "imperial"
      Product.joins(:species).where('products.species_id = ? AND products.is_active = ?', species_id,1).select("distinct(products.thickness_imperial_net),products.thickness_metric_net,products.species_id")
    else
      Product.joins(:species).where('products.species_id = ? AND products.is_active = ?', species_id,1).select("distinct(products.thickness_metric_net), products.thickness_imperial_net,products.species_id")
    end
  end

  # Given a species_id, and thickness value this returns the available widths of the
  # active products.
  # @param: species_id - the species to that we want available widths from
  # @param: thickness - the thickness value we want to find available widths from
  # @param: measurement - a string describing which unit of measure the other
  #                       params are represented as.
  def self.available_width(species_id, thickness, measurement)
    if measurement == "imperial"
      Product.joins(:species).where('products.species_id = ? AND products.thickness_imperial_net = ? AND products.is_active = ?', species_id,thickness, 1).select("distinct(products.width_imperial_net),products.width_metric_net")
    else
      Product.joins(:species).where('products.species_id = ? AND products.thickness_metric_net = ? AND products.is_active = ?', species_id,thickness, 1).select("distinct(products.width_metric_net),products.width_imperial_net")
    end
  end
  # Given a species_id, and thickness value this returns the available  grades of the
  # active products.
  # @param: species_id - the species to that we want available grades from
  # @param: thickness - the thickness value we want to find available grades from
  # @param: measurement - a string describing which unit of measure the other
  #                       params are represented as.
  def self.available_grades(species_id, thickness, width, measurement)
    if measurement == "imperial"
      Grade.joins(:product).where('products.species_id = ? AND products.thickness_imperial_net = ? AND products.width_imperial_net = ? AND products.is_active = ?', species_id,thickness,width, 1).select("distinct(grades.name)")
    else
      Grade.joins(:product).where('products.species_id = ? AND products.thickness_metric_net = ? AND products.width_metric_net = ? AND products.is_active = ?', species_id,thickness,width, 1).select("distinct(grades.name)")
    end
  end
  
  # Finds additonal products to display with the search results 
  # @param lim - the amount of products to return
  def self.additional_products(species_id, grade_id, lim)
    Product.joins(:species, :grade).where('products.species_id = ? AND products.is_active = ? AND products.grade_id = ?', species_id,1,grade_id).limit(lim)
  end

  # Finds the products that match the metric search parameters on the net measurements
  def self.search_products(species_id, thickness, width, grade_id, measurement)
    if measurement == "imperial"
      Product.joins(:species, :grade).where('products.species_id = ? AND products.thickness_imperial_net > ? AND products.thickness_imperial_net <= ? AND products.width_imperial_net > ? AND products.width_imperial_net <= ? AND products.is_active = ? AND products.grade_id = ?', species_id, (thickness.to_d -  self.THICKNESS_RANGE_I),(thickness.to_d +  self.THICKNESS_RANGE_I),(width.to_d - self.WIDTH_RANGE_I), (width.to_d + self.WIDTH_RANGE_I),1,grade_id)
    else
      Product.joins(:species, :grade).where('products.species_id = ? AND products.thickness_metric_net > ? AND products.thickness_metric_net <= ? AND products.width_metric_net > ? AND products.width_metric_net <= ? AND products.is_active = ? AND products.grade_id = ?', species_id, (thickness.to_d -  self.THICKNESS_RANGE_M),(thickness.to_d +  self.THICKNESS_RANGE_M),(width.to_d - self.WIDTH_RANGE_M), (width.to_d + self.WIDTH_RANGE_M),1,grade_id)
    end
  end
  
  # assumes measurement is given in millimeters
  # @param: measurement - measurement in mm to be converted
  # @return: inches equivalent of measurement
  def mmToInch(measurement)
    return (measurement.to_d / 25.4) #millimeters per inch
  end
  
  # assumes measurement is given in inches
  # @param: measurement - measurement in inches to be converted
  # @return: millimeter equivalent of measurement
  def inchToMM(measurement)
    return (measurement.to_d * 25.4) #millimeters per inch
  end
  
  # Convert Meters to Feet
  # @param: measurement - meters to be converted to feet
  # @return: feet equivalent of the measurement
  def metersToFeet(measurement)
    return measurement.to_d * 3.28084
  end
  
  # Convert Feet to Meters
  # @param: measurement - feet to be converted to meters
  # @return: meters equivalent of the measurement
  def feetToMeters(measurement)
    return (measurement.to_d / 3.28084)
  end

  #TODO not called anywhere
  #assumes measurement is a string of the form "x/4" 
  #returns millimeter equivalent of measurement
  def quarterToDatabase(measurement)
    quarterInches = measurement[0, measurement.index('/')] 
    inches = quarterInches / 4
    return inches * 25.4
  end
  #TODO not called by anything
  #assumes measurement is given in millimeters
  #returns string: inch equivalent of measurement in the form "x/4" 
  def quarterFromDatabase(measurement)
    inches = measurement / 25.4
    quarterInches = (inches * 4).round
    return quarterInches.to_s() << "/4"
  end

  # Conversion from cubic meters to board footage
  # @param - cubic_meters - measurement given in cubic meters
  # @return - Measurement in board footage
  def m3ToBF(cubic_meters)
    return (cubic_meters.to_d / (0.002357))
  end
  
  # Conversion from board footage to cubic meters
  # @param - footage - measurement given in footage
  # @return - Measurement in cubic meters
  def bfToM3(footage)
    return (footage.to_d * (0.002357))
  end
  
  # Product listed in inches and need to calculate the actual board feet
  # [(actual thicknes * actual width) / (gross thickness * gross width)] * gross board feet
  # **Note see documentation for explanition between gross and net measurements
  # @param: params - the hash of product parameters
  # @return: the net amount of board feet
  def netBF(params)
    return (((params[:thickness_imperial_net].to_d * params[:width_imperial_net].to_d) / 
           (params[:thickness_imperial_gross].to_d * params[:width_imperial_gross].to_d)) * params[:board_feet].to_d)
  end
  
  # Product listed in millimeters and need to calculate the actual cubic meters
  #   [(actual thicknes * actual width) / (gross thickness * gross width)] * gross cubic meters
  # @param: params - the hash of product parameters
  # @return: the net amount of cubic meters
  def netM3(params)
    return (((params[:thickness_metric_net].to_d * params[:width_metric_net].to_d)/
            (params[:thickness_metric_gross].to_d * params[:width_metric_gross].to_d)) * params[:cubic_meters].to_d)
  end

  # Product was input in metric and this function is used to convert
  # those values into imperial equiavlent measurements to be stored in the database.
  # @param - params - a hash of the product parameters
  # @return - an updated params hash with the parameters containing 
  #           the converted measurments
  def convertProductToImperial(params)
    params[:thickness_actual] = mmToInch(params[:thickness_metric])
    params[:width_actual] = mmToInch(params[:width_metric])
    params[:length_imperial_lower] = metersToFeet(params[:length_metric_lower])
    if params[:length_metric_upper].blank? # If range is blank then assign nil
      params[:length_imperial_upper] = nil
      params[:length_metric_upper] = nil
    else
      params[:length_imperial_upper] = metersToFeet(params[:length_metric_upper])
    end
    params[:board_feet] = m3ToBF(params[:cubic_meters])
    return params
  end
  
  # Product was input in imperial and this function is used to convert
  # those values into metric equiavlent measurements to be stored in the database.
  # @param - params - a hash of the product parameters
  # @return - an updated params hash with the parameters containing 
  #           the converted measurments
  def convertProductToMetric(params)
    if params[:thickness_actual].blank?
      params[:thickness_actual] = params[:thickness_imperial].to_r.to_f
    end
    if params[:width_actual].blank?
      params[:width_actual] = params[:width_imperial].to_r.to_f
    end
    params[:thickness_metric] = inchToMM(params[:thickness_actual])
    params[:width_metric] = inchToMM(params[:width_actual])
    params[:length_metric_lower] = feetToMeters(params[:length_imperial_lower])
    if params[:length_imperial_upper].blank?
      params[:length_metric_upper] = nil
      params[:length_imperial_upper] = nil
    else
      params[:length_metric_upper] = feetToMeters(params[:length_imperial_upper])
    end
    params[:cubic_meters] = bfToM3(params[:board_feet])
    return params
  end
  
  # Must validate input is numeric prior to conversions
  #   this method is chosen if the product was entered in metric
  # @param: params - the product hash of values
  def validateMetric(params)
    params[:thickness_metric] = add_zero_to_decimal_val(params[:thickness_metric])
    params[:width_metric] = add_zero_to_decimal_val(params[:width_metric])

    not_zero(params[:thickness_metric],"thickness")
    not_zero(params[:cubic_meters], "cubic meters")
    
    is_numeric(params[:width_metric], "width")
    if params[:length_metric_upper].blank?
      is_numeric(params[:length_metric_lower],"length")
    else
      is_numeric(params[:length_metric_lower],"lower range of length")
      is_numeric(params[:length_metric_upper],"upper range of length")
    end
  end
  
  # Must validate input is numeric prior to conversions
  #   this method is used if the product was entered in imperial
  # @param: params - the product hash of values
  def validateImperial(params)
    params[:thickness_imperial] = add_zero_to_decimal_val(params[:thickness_imperial])
    params[:thickness_actual] = add_zero_to_decimal_val(params[:thickness_actual])
    params[:width_imperial] = add_zero_to_decimal_val(params[:width_imperial])
    params[:width_actual] = add_zero_to_decimal_val(params[:width_actual])

    not_zero(params[:board_feet], "board feet")
    if params[:length_imperial_upper].blank?
      is_numeric(params[:length_imperial_lower],"length")
    else
      is_numeric(params[:length_imperial_lower],"lower range of length")
      is_numeric(params[:length_imperial_upper],"upper range of length")
    end
  end
  
  # Used to remove any whitespace captured upon user input
  #   and to place a '0' in front of any decimal number (ie .90)
  #   as ruby does not allow .90 as a float w/o the 0.
  def add_zero_to_decimal_val(measurement)

    measurement = measurement.to_s.strip
    if measurement[0] == '.'
      measurement= measurement.prepend("0")
    end
    return measurement
  end
  
  # Checks if a value is numeric then checks for zero
  # @param: s - the variable being checked as numeric and for zero
  # @param: name - the name to be associated with the error if one is found
  # @return: product object is stored with an error if one is found
  def not_zero(s,name)
    if is_numeric(s,name)
      if s.to_d == 0
        self.errors.add(name, "cannot be 0")
      end
    end
  end
  
  # Used to determine if a value is numeric
  # @param: s - the variable being matched as numeric
  # @param: name - the name to be associated with the error if one is found
  # @return: boolean whether s was numeric
  # @return: if s is not numeric then an error is stored with the product
  def is_numeric(s,name)
    puts s.to_s
    if s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil
      self.errors.add(name, "must be a number")
      return false
    end
    return true
  end

  # variables representing the desired range of products returned in a search
  def self.WIDTH_RANGE_M
    return 10
  end
  def self.THICKNESS_RANGE_M
    return 10
  end
  def self.WIDTH_RANGE_I  
    return 0.5
  end
  def self.THICKNESS_RANGE_I  
    return 0.5
  end
end
