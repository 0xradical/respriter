# !/usr/bin/env bash

echo "Cleaning old pipeline templates and executions from db..."
cd ..
bin/psql napoleon -c '"delete from app.pipeline_executions"'
bin/psql napoleon -c '"delete from app.pipeline_templates;"' 
cd napoleon/

echo "Cleaning old setup.sql..."
rm -f db/seeds/coursera/setup.sql

echo "Recreating setup.sql..."
make build-seeds-coursera

echo "Recreating pipeline templates on db"
make setup-provider-coursera

echo "Inserting new pipeline execution on db..."
cd ..
bin/psql napoleon -c $'"INSERT INTO app.pipeline_executions (  pipeline_template_id, name, dataset_id, schedule_interval, run_at ) SELECT   id, \'Coursera\',  \'0e9cdf2c-44e7-11e9-8c55-22000aef2c9b\', \'14 days\', NOW() FROM app.pipeline_templates WHERE name = \'Coursera Sitemap Pipeline\';"'