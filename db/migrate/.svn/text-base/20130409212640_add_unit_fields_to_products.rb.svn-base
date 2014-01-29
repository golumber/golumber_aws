class AddUnitFieldsToProducts < ActiveRecord::Migration
  #Precision is the significant digits
  #scale is the number of decimal values
  def change
    remove_column :products, :thickness
    remove_column :products, :actual_thickness
    remove_column :products, :width
    remove_column :products, :actual_width
    remove_column :products, :BF_M3
    remove_column :products, :length
    
    add_column :products, :thickness_metric_gross, :decimal, :precision => 4, :scale => 1
    add_column :products, :thickness_metric_net, :decimal, :precision => 4, :scale => 1
    add_column :products, :thickness_fractional, :text
    add_column :products, :thickness_imperial_net, :decimal, :precision => 5, :scale => 3
    add_column :products, :thickness_imperial_gross, :decimal, :precision => 5, :scale => 3
    
    add_column :products, :width_metric_gross, :decimal, :precision => 4, :scale => 1
    add_column :products, :width_metric_net, :decimal, :precision => 4, :scale => 1
    add_column :products, :width_fractional, :text
    add_column :products, :width_imperial_net, :decimal, :precision => 5, :scale => 3
    add_column :products, :width_imperial_gross, :decimal, :precision => 5, :scale => 3
    
    add_column :products, :length_metric_lower, :decimal, :precision => 3, :scale => 1
    add_column :products, :length_metric_upper, :decimal, :precision => 3, :scale => 1
    add_column :products, :length_imperial_lower, :decimal, :precision => 4, :scale => 2
    add_column :products, :length_imperial_upper, :decimal, :precision => 4, :scale => 2
    
    
    add_column :products, :BF, :decimal, :precision => 6, :scale => 0
    add_column :products, :BF_net, :decimal, :precision => 6, :scale => 0
    add_column :products, :M3, :decimal, :precision => 8, :scale => 2
    add_column :products, :M3_net, :decimal, :precision => 8, :scale => 2
    
  end
end
