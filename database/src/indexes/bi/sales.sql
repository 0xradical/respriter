CREATE INDEX index_sales_on_date
ON bi.sales
USING btree (date);
