# Tickets Search API
This is a tickets search API which implemented by ruby, includes tickets, users, organizations search

## How to Run

### in Docker
```bash
docker build -t ticket-search .
docker run --rm -it --name ticket-search-app ticket-search


### notes

file = File.read('./lib/data_source/organizations.json')

data = JSON.parse(file, symbolize_names: true)

