class FixProductMeasurementColumns < ActiveRecord::Migration
  def up
    remove_column :products, :thickness_metric_gross
    rename_column :products, :thickness_metric_net, :thickness_metric
    
    remove_column :products, :width_metric_gross
    rename_column :products, :width_metric_net, :width_metric
    
    remove_column :products, :thickness_imperial_net
    rename_column :products, :thickness_fractional, :thickness_imperial
    rename_column :products, :thickness_imperial_gross, :thickness_actual
    
    remove_column :products, :width_imperial_net
    rename_column :products, :width_fractional, :width_imperial
    rename_column :products, :width_imperial_gross, :width_actual
    
    remove_column :products, :BF_net
    remove_column :products, :M3_net
  end

  def down
    add_column :products, :thickness_metric_gross, :decimal
    rename_column :products, :thickness_metric, :thickness_metric_net
    
    add_column :products, :width_metric_gross, :decimal
    rename_column :products, :width_metric, :width_metric_net
    
    add_column :products, :thickness_imperial_net, :decimal
    rename_column :products, :thickness_imperial, :thickness_fractional
    rename_column :products, :thickness_actual, :thickness_imperial_gross
    
    add_column :products, :width_imperial_net, :decimal
    rename_column :products, :width_imperial, :width_fractional
    rename_column :products, :width_actual, :width_imperial_gross
    
    add_column :products, :BF_net, :decimal
    add_column :products, :M3_net, :decimal
  end
end
