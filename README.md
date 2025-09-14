# API Test Suite (RSpec + HTTParty)

This repository contains automated API tests written in Ruby, using **RSpec** as the test runner and **HTTParty** as the HTTP client library.

The suite covers:
- **Positive tests** for the Giphy Search API (GIFs, Stickers, Videos, etc.)
- **Negative tests** (invalid API key)
- **Data-driven testing** (queries, limits, offsets, types)
- Support for tagging tests as **smoke**, **regression**, or **negative**

## Setup

Install dependencies:
    bundle install

Add your environment variables (e.g. API base URL and key) in a `.env` file:
    API_BASE_URL=https://api.giphy.com/v1
    API_KEY=your_api_key_here

## Note: you can either use the public API key that Giphy exposes in their frontend (visible in the browser’s network tab), or generate your own developer key by signing up on Giphy’s developer portal.


## Running Tests

Run all tests:
    bundle exec rspec

Run only smoke tests:
    bundle exec rspec --tag smoke

Run only regression tests:
    bundle exec rspec --tag regression

Run only negative tests:
    bundle exec rspec --tag negative

Run tests with detailed output:
    bundle exec rspec --format documentation



