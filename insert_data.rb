require "pg"
require "csv"

def create(table, data, unique_column)
  entity = unique_column.nil? ? nil : find(table, unique_column, data[unique_column])
  return entity if entity

  # INSERT INTO clients(name, age, gender, occupation, nationality)
  # VALUES ('Jewel Daniel', '28', 'MALE', 'Physicist', 'Romanians')
  # en INTEGER en postgres tambien puede ir en '28' acepta normal
  # data.keys.join(",") => "name,age,gender,occupation,nationality";
  # data.values.map{|value| "'#{value.gsub("'","''")}'"}.join(",") => "'Darin Littel','62','Male','Coach','Mauritians'"
  data_insert = DB.exec(%[INSERT INTO #{table}(#{data.keys.join(',')}) VALUES (#{data.values.map do |value|
                                                                                   "'#{value.gsub("'", "''")}'"
                                                                                 end.join(',')}) RETURNING *])
  # query.first => {"id"=>"1", "name"=>"Jewel Daniel", "age"=>"28", "gender"=>"Male",
  # "occupation"=>"Physicist", "nationality"=>"Romanians"} de cada fila que inserta
  data_insert.first
end

def find(table, column, column_value)
  value = DB.exec(%(SELECT * FROM #{table} WHERE #{column} = '#{column_value.gsub("'", "''")}'))
  value.first
end

# getting ARGV
bd_name, csv_file = ARGV
ARGV.clear

DB = PG.connect(dbname: bd_name)
CSV.foreach(csv_file, headers: true) do |row|
  # p row["visit_date"]
  # {
  #   "name" => "cristhian",
  #   "age" => 30,
  #   "gender" => "m"
  # }
  # p client_data.first
  # sale solo el primer key value osea ["name", "cristhian"] en arreglo
  client_data = {
    "name" => row["client_name"],
    "age" => row["age"],
    "gender" => row["gender"],
    "occupation" => row["occupation"],
    "nationality" => row["nationality"]
  }
  # p client_data["name"]
  client = create("clients", client_data, "name")

  restaurant_data = {
    "name" => row["restaurant_name"],
    "category" => row["category"],
    "city" => row["city"],
    "address" => row["address"]
  }
  restaurant = create("restaurants", restaurant_data, "name")

  dish_data = {
    "name" => row["dish"]
  }
  dish = create("dishes", dish_data, "name")

  price_data = {
    "price" => row["price"],
    "restaurant_id" => restaurant["id"],
    "dish_id" => dish["id"]
  }
  price = create("prices", price_data, nil)

  visit_data = {
    "visit_date" => row["visit_date"],
    "client_id" => client["id"],
    "price_id" => price["id"]
  }
  create("visits", visit_data, nil)
end
