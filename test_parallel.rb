ENV['CONSOLE_LEVEL'] = 'fatal' # turns off async logging exc to stdout
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

  def test_is_parallel
    # The test server takes 0.5 seconds to run, so 10 requests should take 5 seconds if done serially
    5.times do |i|
      @parallel_service.add_work(url: "http://localhost:8080/#{i}")
    end

    start_time = Time.now
    @parallel_service.fetch_all
    end_time = Time.now

    assert end_time - start_time < 1
  end

  def test_add_work_and_fetch_all
    5.times do |i|
      @parallel_service.add_work(url: "http://localhost:8080/#{i}")
    end

    results = @parallel_service.fetch_all

    assert_kind_of Array, results

    assert_equal ["/0", "/1", "/2", "/3", "/4"], results
  end

  def test_semaphore
    # The test server takes 0.5 seconds to run, so 10 requests should take >1 second if done in parallel
    10.times do |i|
      @parallel_service.add_work(url: "http://localhost:8080/#{i}")
    end

    start_time = Time.now
    @parallel_service.fetch_all
    end_time = Time.now

    assert end_time - start_time > 1
  end

  def test_failure
    5.times do |i|
      @parallel_service.add_work(url: "http://localhost:50/fail")
    end

    # TODO: better interface for this?
    assert_raises(Errno::ECONNREFUSED) do
      result = @parallel_service.fetch_all
      binding.irb
    end
  end
end
