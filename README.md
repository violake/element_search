# Tickets Search API
This is a tickets search API which implemented by ruby, includes tickets, users, organizations search

## How to Run

### in Docker

#### prerequisites

- docker installed

#### start zendesk search

```bash
docker build -t zendesk-search .
docker run --rm -it --name zendesk-search-app zendesk-search

```

### in local

#### prerequisites

- ruby 3.0.1 installed
#### install gems

```bash
bundle install
```

#### test
#### coverage/index.html shows test coverage details

```bash
rspec
```

#### code format

```bash
rubocop
```

#### start zendesk search
```bash
./scripts/run_zendesk_search.rb
```

