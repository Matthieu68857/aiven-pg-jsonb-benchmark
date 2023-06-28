SELECT * FROM benchmark.users WHERE document->>'_id' = (select id from benchmark.ids order by RANDOM() limit 1);
SELECT * FROM benchmark.users, (select last_name, first_name from benchmark.names order by RANDOM() limit 1) as names WHERE document->>'lastName' = names.last_name and document->>'firstName' = names.first_name;