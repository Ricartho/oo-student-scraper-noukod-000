require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    doc = Nokogiri::HTML(open(index_url))
    student = doc.search(".student-card")
    
    student.each do |el|
      name = el.search(".student-name").text
      location = el.search(".student-location").text
      profile_url = el.search("a").attribute("href").value
      
      student_hash = { 
          
            :name => name,
            :location => location,
            :profile_url => profile_url
      }
      students_array.push(student_hash)
    end 
    students_array
  end 

  def self.scrape_profile_page(profile_url)
     students_hash = {}
     doc = Nokogiri::HTML(open(profile_url))
     links = doc.search(".social-icon-container a").map {|el| el.attribute("href").value}
     
     links.each do |el|
      if el.include?("twitter")
        students_hash[:twitter] = el
      elsif el.include?("linkedin")
        students_hash[:linkedin] = el
      elsif el.include?("github")
        students_hash[:github] = el
      elsif el.include?(".com")
        students_hash[:blog] = el
      end 
      
     end 
      students_hash[:profile_quote] = doc.search(".profile-quote").text
      students_hash[:bio] = doc.search(".description-holder p").text
      students_hash
  end 
  
end 