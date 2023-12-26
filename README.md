# Prepare

## dotenv

**.env** has to be in the same folder as the arte executable (.exe/.sh)
```sh
cp .env.example .env
```

## database

**restore dump** schema and basic data
```sh
psql -h localhost -U postgres -d postgres < migrations/001_schema.sql
psql -h localhost -U postgres -d postgres < migrations/002_data.sql
```

**dump** database `data only`
```sh
pg_dump -h localhost -U postgres -n public --data-only > data.sql
```

# Usage
```sh
arte.sh --mode film
arte.sh --mode film --force
arte.sh --mode film --arte 083874-000-A
```

