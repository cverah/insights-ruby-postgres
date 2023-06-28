require "pg"
require "terminal-table"

require_relative "query_methods"

class Insight
  def initialize
    @db = PG.connect(dbname: "insights")
    # p @db
  end

  def start
    print_welcome
    print_menu
    gets_options
  end

  private

  def print_welcome
    puts "Welcome to the Restaurants Insights!"
    puts "Write 'menu' at any moment to print the menu again and 'quit' to exit."
  end

  def print_menu
    puts "---"
    puts "1. List of restaurants included in the research filter by ['' | category=string | city=string]"
    puts "2. List of unique dishes included in the research"
    puts "3. Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]"
    puts "4. Top 10 restaurants by the number of visitors."
    puts "5. Top 10 restaurants by the sum of sales."
    puts "6. Top 10 restaurants by the average expense of their clients."
    puts "7. The average consumer expense group by [group=[age | gender | occupation | nationality]]"
    puts "8. The total sales of all the restaurants group by month [order=[asc | desc]]"
    puts "9. The list of dishes and the restaurant where you can find it at a lower price."
    puts "10. The favorite dish for [age=number | gender=string | occupation=string | nationality=string]"
    puts "---"
    puts "Pick a number from the list and an [option] if necessary"
  end

  def gets_options
    action = nil
    until action == "exit"
      print "> "
      action_option = gets.chomp
      action, param = action_option.split
      case action
      when "1" then list_restaurants(action_option, param)
      when "2" then list_dishes
      when "3" then number_distribution_users(param)
      when "4" then top_restaurants_visitors
      when "5" then top_restaurants_sales
      when "6" then top_restaurants_average
      when "7" then average_consumer_expense(param)
      when "8" then sales_all_month(param)
      when "9" then best_price_restaurant
      when "10" then favorite_dish_restaurant(param)
      when "menu" then puts print_menu
      when "exit" then puts "Thank you goodbye!"
      else
        puts "option invalide"
      end
    end
  end

  # query case options
  include Queryable

  # print table
  def print_table(title, query)
    result = @db.exec(query)
    table = Terminal::Table.new
    table.title = title
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
end

insight = Insight.new
insight.start
