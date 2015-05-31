# Use this file to import the sales information into the
# the database.

require "pg"
require "csv"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

sales_data = []
  CSV.foreach("sales.csv", headers: true, header_converters: :symbol) do |row|
  sales_data << row.to_hash
end

employees = sales_data.map do |element|
  element[:employee]
end.uniq

employees.each do |employee|
  # array of name, email
  employee_array = employee.gsub(')', '').split(' (')

db_connection do |conn|
 conn.exec_params("INSERT INTO employees (employee_name, employee_email) VALUES ($1, $2)", employee_array)
  end
end



sales_table_array = []
sales_data.each do |element|
  sale_date = element[:sale_date]
  sale_amount = element[:sale_amount]
  units_sold = element[:units_sold]
  invoice_no = element[:invoice_no]
  invoice_frequency = element[:invoice_frequency]
  # product_name = element[:product_name]
  # product_id = db_connection do |conn|
  #   conn.exec_params("SELECT id FROM products WHERE product_name = $1", product_name).
  # end
  # binding.pry
  # product_id =
  # employee_id =
  # customer_id =
  sales_table_array << [sale_date, sale_amount, units_sold, invoice_no, invoice_frequency]
end

sales_table_array.each do |item|

db_connection do |conn|
 conn.exec_params("INSERT INTO sales (sale_date, sale_amount, units_sold, invoice_no, invoice_frequency) VALUES ($1, $2, $3, $4, $5)",
   item)
 end
end


customers = sales_data.map do |element|
  element[:customer_and_account_no]
end.uniq

 customers.each do |customer|
   customer_array = customer.gsub(')', '').split(' (')

   db_connection do |conn|
    conn.exec_params("INSERT INTO customers (customer_name, customer_account) VALUES ($1, $2)", customer_array)
   end
 end



products = sales_data.map do |element|
  element[:product_name]
end.uniq

products.each do |item|

  db_connection do |conn|
 conn.exec_params("INSERT INTO products (product_name) VALUES ($1)", [item])
end
end
