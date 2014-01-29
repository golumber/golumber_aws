require 'spec_helper'

describe Species do
	before do
		@species = Species.new(:name => 'Test')
	end

	describe "accessible attributes" do
		it "should allow access to name" do
			expect do
				Species.new(name: true)
			end.to_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end

		it "should allow access to company_id" do
			expect do
				Species.new(company_id: true)
			end.to_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "database relationships" do
		describe "has_many relationships" do
			it {should have_many(:products)}
		end

		describe "has_and_belongs_to_many relationships" do
			it {should have_and_belong_to_many(:companies)}
		end
	end

	describe "validates" do
		describe "presence of name" do
			it {should validate_presence_of(:name)}
		end

		describe "uniqueness of name" do
			it {should validate_uniqueness_of(:name)}
		end
	end

	describe "name maximum length" do
		before {@species.name = "a" *27}
		it {should_not be_valid}
	end
end