# Add a declarative step here for populating the DB with movies.
# 
require 'pry'

Given /the following movies exist/ do |movies_table|

  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    Movie.create!(movie)

  end

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  
  pos1 = page.body.match /#{e1}/
  pos2 = page.body.match /#{e2}/

  pos1 should be < pos2

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  ratings = rating_list.split(',')

  if uncheck == nil
    
    ratings.each do |rating|
          check "ratings_#{rating}"
    end

  else
    
    ratings.each do |rating|
          uncheck "ratings_#{rating}"
    end
  
  end   
  
end


When /I check all of the ratings/ do 

  step "I check the following ratings: G,PG,PG-13,R"

end


Then /^I should (not )?see movies with the following ratings: (.*)/ do |isVisible, rating_list|

  movies_with_rating = Movie.where(:rating => [rating_list.split(',')])

  titles = movies_with_rating.map do |movie|

    movie[:title]

  end

  selected_movies = page.all('#movies tr td:first-child')

  binding.pry
  
  selected_movies.each do |check_movie|

    title = check_movie.native.text

    if isVisible == nil
      titles.should include(title)
    else
      titles.should_not include title
    end

  end

end
