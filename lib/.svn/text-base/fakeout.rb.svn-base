# place this in lib/fakeout.rb

require 'ffaker'

module Fakeout
  class Builder

    FAKEABLE = %w(Product Grade CompaniesGrade Employee MailingList)
    
    attr_accessor :report

    def initialize
      self.report = Reporter.new
      clean!
    end

    # create companies
    def companies(count = 1, options = {}, is_admin = false)
      1.upto(count) do  0.0
        name = Faker::Company.name
        attributes = {    :city           => Faker::Lorem.words(1).to_s.capitalize,
                          :name   => name,
                          :state          => Faker::Address.us_state(),
                          :phone_number   => Faker::PhoneNumber.phone_number,
                          :street_address => Faker::Address.street_address,
                          :zip_code       => Faker::Address.zip_code,
                          :website        => "www.#{name}.com",
                          :country        => Faker::Lorem.words(1).to_s.capitalize}.merge(options)
        company = Company.new(attributes)
        company.save
        if is_admin
          company.update_attribute(:is_admin, true)
          self.report.increment(:admins, 1)
        end
      end

      self.report.increment(:companies, count)
    end
    
    def employees(count = 1, options = {})
      1.upto(count) do
        email = Faker::Internet.email
        attributes = {    :first_name                       => Faker::Name.first_name,
                          :last_name                        => Faker::Name.last_name,
                          :email                            => email,
                          :email_confirmation               => email,
                          :phone_number                     => Faker::PhoneNumber.phone_number,
                          :encrypted_password               => "Pword1234",
                          :company_id                       => pick_random(Company)}.merge(options)
        employee = Employee.new(attributes)
        employee.save
      end

      self.report.increment(:employees, count)      
    end

    def grades(count = 1, options = {})
      1.upto(count) do
        companyId = pick_random(Company)
        gradeName = "grade#{Random.rand(10)}"
        grade = Grade.where(name: gradeName)[0]
        if grade.nil?
          attributes = {    :name           => gradeName,
                            :description    => gradeName}.merge(options)
          grade = Grade.new(attributes)
          grade.save
          self.report.increment(:grades, 1)
        end
        companiesGrade = CompaniesGrade.where(grade_id: grade['id'], company_id: companyId)[0]
        if companiesGrade.nil?
          attributes = {    :company_id     => companyId,
                            :grade_id       => grade['id']}.merge(options)
          companiesGrade = CompaniesGrade.new(attributes)
          companiesGrade.save
          self.report.increment(:companies_grades, 1)
        end
      end
    end

    # create products
    # TODO provide accurate values for the fields below
    def products(count = 1, options = {})
      1.upto(count) do
        thick_fake_i = Random.rand(1.0..10.0)
        thick_fake_m = (thick_fake_i * 25.4)
        thick_fake_wi = Random.rand(1.0..15.0)
        thick_fake_wm = (thick_fake_wi * 25.4)
        bfToM3_fake = Random.rand(100000)
        m3_fake = (bfToM3_fake * (0.002357))
        attributes   = { :thickness_metric   => thick_fake_i,
                         :thickness_imperial   => thick_fake_m,
                         :thickness_actual   => thick_fake_i,
                         :width_metric   => thick_fake_i,
                         :width_imperial   => thick_fake_m,
                         :width_actual   => thick_fake_i,
                         :length_metric_lower      => Random.rand(2),
                         :length_metric_upper      => 2+Random.rand(2),
                         :length_imperial_lower      => Random.rand(8),
                         :length_imperial_upper     => 8+Random.rand(2),
                         :board_feet => bfToM3_fake,
                         :cubic_meters => m3_fake,
                         :details     => Faker::Lorem.paragraph(2),
                         :species_id  => pick_random(Species),
                         :grade_id    => pick_random(Grade),
                         :company_id  => pick_random_c(Company),
                         :is_active   => 1}.merge(options)
        product = Product.new(attributes)
        product.save
      end
      self.report.increment(:products, count)
    end

    # cleans all faked data away100
    def clean!
      FAKEABLE.map(&:constantize).map(&:destroy_all)
    end

    def mailing_lists(count = 1, options = {})
      1.upto(count) do
        attributes = { :email => random_unique_email(),
                       :contact_first => Faker::Name.first_name,
                       :contact_last => Faker::Name.last_name,
                       :company_id => pick_random(Company)}.merge(options)
        mailing_list = MailingList.new(attributes)
        mailing_list.save
      end
      self.report.increment(:mailing_list, count)
    end

    private

    def pick_random(model)
      ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
      count = ids.length
      index = rand(count)
      a = ids[index]
      #ids is an array of hashes, so extract a random index, and grab the first value of that hash
      myvalue = a.values[0]
      return myvalue.to_i if ids
    end
    
  def pick_random_c(model)
    ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
    count = ids.length
    index = rand(count)
    a = ids[index]
    #ids is an array of hashes, so extract a random index, and grab the first value of that hash
    myvalue = a.values[0]
    return myvalue.to_i if ids
  end

    def random_unique_email
      Faker::Internet.email.gsub('@', "+#{Company.count}@")
    end
  end


  class Reporter < Hash
    def initialize
      super(0)
    end

    def increment(fakeable, number = 1)
      self[fakeable.to_sym] ||= 0
      self[fakeable.to_sym] += number
    end

    def to_s
      report = ""
      each do |fakeable, count|
        report << "#{fakeable.to_s.classify.pluralize} (#{count})\n" if count > 0
      end
      report
    end
  end
end
