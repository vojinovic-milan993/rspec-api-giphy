require "spec_helper"

RSpec.describe "Giphy Search API" do
  let(:client) { ApiClient.new }

  # this could be a csv or json, and placed outside of the test
  test_data = [
    { query: "sunshine", limit: 3, offset: 0, type: "gifs",     tags: [:smoke, :regression] },
    { query: "sunshine", limit: 5, offset: 5, type: "stickers", tags: [:regression] },
    { query: "good morning", limit: 2, offset: 0, type: "videos", tags: [:regression] },
    { query: "morning",  limit: 4, offset: 4, type: "gifs",     tags: [:regression] },
    { query: "cat",      limit: 50, offset: 10, type: "stickers", tags: [:regression] },
    { query: "randomqueryajsdjasjdsa", limit: 5, offset: 5, type: "videos", tags: [:regression] }
  ]

  test_data.each do |td|
    it "returns results for query='#{td[:query]}' with limit=#{td[:limit]} and offset=#{td[:offset]}", *td[:tags] do
      response = client.get("/#{td[:type]}/search", params: {
        q: td[:query],
        limit: td[:limit],
        offset: td[:offset]
      })

      # puts "STATUS: #{response.code}"
      # response.parsed_response["data"].each_with_index do |item, i|
      #   title = item["title"]
      #   tags  = item["tags"] || []
      #   puts "#{td[:type].capitalize} #{i + 1}:"
      #   puts "  Title: #{title}"
      #   puts "  Tags:  #{tags.join(', ')}"
      # end

      expect(response.code).to eq(200)

      body = response.parsed_response
      data = body["data"]

      if data.empty?
        puts "No results found for query='#{td[:query]}'"
      else
        expect(data.size).to be <= td[:limit]

        query = td[:query].downcase
        all_search_data = data.all? do |item|
          title = item["title"].downcase
          tags  = (item["tags"] || []).map(&:downcase)
          ok = title.include?(query) || tags.any? { |t| t.include?(query) }
          puts "Irrelevant #{td[:type]}: #{item['title']}" unless ok
          ok
        end
        expect(all_search_data).to be true

        pagination = body["pagination"]
        expect(pagination["offset"]).to eq(td[:offset])
        expect(pagination["count"]).to be <= td[:limit]
      end
    end
  end

  context "negative scenarios" do
    it "returns 401 when using an invalid API key", :negative do
      bad_client = ApiClient.new(api_key: "invalid_key")
      response = bad_client.get("/gifs/search", params: { q: "cat", limit: 3 })

      expect(response.code).to eq(401)
      puts "Negative test: received #{response.code} for invalid key"
      end
    end
  end

