# loan-decisions

## Requirements

You need docker and docker-compose

## Run

    docker-compose build
    docker-compose up
    # http://localhost:3000

## Tests

    docker-compose run --rm app bash
    ruby test/loan_service_test.rb
