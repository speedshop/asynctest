require 'minitest/autorun'
require 'async'

if ENV['IMPLEMENTATION'] == 'async'
  require_relative 'parallel_http_async'
elsif ENV['IMPLEMENTATION'] == 'concurrent'
  require_relative 'parallel_http_concurrent'
else
  raise "IMPLEMENTATION must be set to async or concurrent"
end

class TestParallelHTTP < Minitest::Test
  def setup
    @parallel_service = Parallel::HTTP.new
  end

  def test_add_work_and_fetch_all
    # Add 10 URLs to the service
    10.times do |i|
      @parallel_service.add_work(url: "http://localhost:8080/#{i}")
    end

    # Fetch all results
    results = @parallel_service.fetch_all

    # Assert that results is an array
    assert_kind_of Array, results

    # Assert that we got 10 results back
    assert_equal 10, results.length
  end
end
