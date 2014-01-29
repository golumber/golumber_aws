require 'fakeout'

namespace :task do
  desc "Fakeout data"
  task :fake => :environment do
    puts "The env is: #{:fake}"
    faker = Fakeout::Builder.new
  
    # fake companies
    #faker.companies(9)
    #faker.companies(1, { :email => 'matt@test.com' }, true)

    # fake grades
    faker.grades(20)

    # fake products
    faker.products(50)
    #faker.products(4, { :price => 0 })
    
    # fake employee
    #faker.employees(12)
    #faker.employee(4, { :price => 0 })    
  
    #faker.mailing_lists(40)
    # report
    puts "Faked!\n#{faker.report}"
  end
end