# SQL-Data-Analysis-Project

# Sales Data Analysis Project (PostgreSQL + Excel)

This project analyzes customer and product sales data using **PostgreSQL (pgAdmin)** and 
exports the results to Excel reports.

##  Folder Structure
- **data/** → Source Excel files 
- **sql/** → SQL scripts for database creation and reports
- **output/** → Final report results in Excel

##  Tools Used
- PostgreSQL (pgAdmin)
- Excel for data input/output
- Github for project sharing

##  How to Use
1. Raw data is available in file name gold.dim_customers , gold.dim_products and gold.fact_sales.
2. Create schema using `Database_Creation.sql`
3. Load data from Excel files into tables
4. There is sql file name 'Part' in which I query the data in four parts and the final query to get final report is 
   done in sql file name 'Report'.
5. View the final reports in the `output` csv folder. There are two output one for customer and other for product.

