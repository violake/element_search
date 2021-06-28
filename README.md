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
./scripts/start_zendesk_search.rb
```

## Design

- This seems like elastic search, so inverted index is my solution for search performance.
- At first I thought it would be a metaprogramming solution then I found it's unnecessary
- There are edge case like error associated key which could cause app broken,
  so for association I chose to return array which could be empty.
- CLI is very interesting application, I set a cli frame class which could adapt any search class
- for memory efficiency, I use class object to save all elements hash and search hash(inverted indexes)


## Test coverage

- I covered almost 100% of the core function of this search app
- For CLI, I didn't write any test as it's not ordinary test and sometime you will have to do some tricky thing
  which does provide much value.