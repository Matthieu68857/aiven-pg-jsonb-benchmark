# Postgres JSONB at scale

## Data generation

To generate data, use the python script `fake_users_generator.py`. 
You can update the number of documents you want to generate by updating the script `num_documents = 35000000`.
```
python fake_users_generator.py
```
This will generate a local file with one document per line `fake_user_documents.json`.

## Data ingestion

You can import the data on your Postgres server by issuing the following `COPY` query:
```
\COPY benchmark.users(document) FROM 'fake_user_documents.json';
```

## Benchmark

To execute the benchmark, we use `pgbench` with customer SQL queries that can be found in the [queries.sql](queries.sql) file of this project.
Those queries are two different SELECT statement, searching for random documents in the database.

To generate the "random" IDs, we used those tables:
```
create table benchmark.ids(id) as select distinct document->>'_id' from benchmark.users limit 100;
create table benchmark.names (last_name, first_name) as select distinct document->>'lastName', document->>'firstName' from benchmark.users limit 100;
```

The following command will run 500 connections on 8 threads for 5 minutes. 
```
pgbench -f queries.sql -c 500 -j 8 -T 300 -P 5 -h <hostname> -p 11322 -U <user> <database>
```

You can adapt any of those queries or parameters according to your usecase.