module Queryable
  # option 1
  def list_restaurants(action_option, param)
    # SELECT name, category, city FROM restaurants;
    if action_option.size > 1
      column, value = param.split("=")
      # 1 category=Italian => column = "category" value=Italian
      query = "SELECT name, category, city FROM restaurants WHERE #{column} like '%#{value}%'"
    else
      query = "SELECT name, category, city FROM restaurants"
    end
    print_table("List of restaurants", query)
  end

  # option 2
  def list_dishes
    query = "SELECT DISTINCT name FROM dishes"
    print_table(" List of dishes", query)
  end

  # option 3
  def number_distribution_users(param)
    column = param.split("=")[1]
    all_rows = @db.exec("SELECT COUNT(*) FROM clients")
    values_all_rows = all_rows.first["count"].to_i
    # p values_all_rows
    query = %[SELECT #{column}, COUNT(#{column}),
     CONCAT(ROUND((COUNT(#{column})*100/#{values_all_rows}::numeric),2),' %') AS percentage
     From clients
     GROUP BY #{column}
     ORDER BY #{column} ASC]

    print_table("Number and Distribution of Users", query)
  end

  # option 4
  def top_restaurants_visitors
    query = "SELECT r.name, COUNT(visit_date) as visitors
    FROM restaurants as r JOIN prices as p ON r.id = p.restaurant_id JOIN visits v ON p.id = v.price_id
    GROUP BY r.name
    ORDER BY visitors DESC
    LIMIT 10"
    print_table("Top 10 restaurants by visitors", query)
  end

  # option 5
  def top_restaurants_sales
    query = "SELECT r.name, SUM(p.price) as sales
    FROM restaurants as r JOIN prices as p ON r.id = p.restaurant_id
    GROUP BY r.name
    ORDER BY sales DESC
    LIMIT 10"
    print_table("Top 10 restaurants by sales", query)
  end

  # option 6
  def top_restaurants_average
    query = %[SELECT r.name, ROUND(AVG(p.price),1) as "avg expense"
    FROM restaurants as r JOIN prices as p ON r.id = p.restaurant_id
    GROUP BY r.name
    ORDER BY "avg expense" DESC
    LIMIT 10]
    print_table("Top 10 restaurants by average expense per user", query)
  end

  # option 7
  def average_consumer_expense(param)
    column = param.split("=")[1]
    column_attribute = {
      "age" => "c.age",
      "gender" => "c.gender",
      "occupation" => "c.occupation",
      "nationality" => "c.nationality"
    }
    query = %[SELECT #{column_attribute[column]}, ROUND(AVG(p.price),2) AS "avg expense"
      FROM clients as c JOIN visits as v ON c.id = v.client_id
      JOIN prices as p ON v.price_id = p.id
      GROUP BY #{column_attribute[column]}
      ORDER BY "avg expense" DESC]
    print_table("Average consumer expenses", query)
  end

  # option 8
  def sales_all_month(param)
    column = param.split("=")[1]
    query = %[SELECT TO_CHAR(v.visit_date,'Month') AS month , SUM(p.price) AS sales
      FROM visits AS v JOIN prices AS p ON v.price_id = p.id
      GROUP BY month
      ORDER BY sales #{column}]
    print_table("Total sales by month", query)
  end

  # option 9
  def best_price_restaurant
    query = "SELECT d.name as dish, MIN(r.name) AS restaurant_name, MIN(p.price) AS price
    FROM prices AS p
    JOIN restaurants AS r ON r.id = p.restaurant_id
    JOIN dishes AS d ON d.id = p.dish_id
    GROUP BY d.name
    ORDER BY MIN(p.price) ASC;
    "
    print_table("Best price for dish", query)
  end

  # option 10
  def favorite_dish_restaurant(param)
    column_ref = {
      "age" => "c.age",
      "gender" => "c.gender",
      "occupation" => "c.occupation",
      "nationality" => "c.nationality"
    }
    column, value = param.split("=")
    column = column_ref[column]
    query = %[SELECT #{column}, d.name AS dish, COUNT(#{column}) AS count
      FROM clients AS c
      JOIN visits AS v ON v.client_id = c.id
      JOIN prices AS p ON p.id = v.price_id
      JOIN dishes AS d ON d.id = p.dish_id
      WHERE #{column} =   '#{value}'
      GROUP BY #{column},d.name
      ORDER BY count DESC
      LIMIT 1
    ]
    print_table("Best price for dish", query)
  end
end
