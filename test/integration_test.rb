require File.expand_path("../test_helper",  __FILE__)

class IntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Rails.cache.clear
    Timecop.freeze("2012-10-10")
  end

  test "Normal mode" do
    get "/"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/"
    assert_response 200
    assert response.body.include?('2012-10-10')
  end

  test "SSI mode" do
    get "/", {}, {"QOR_CACHE_SSI_ENABLED" => 1}
    assert_response 200
    assert response.body.include?(%Q[<!--# include virtual="/qor_cache_includes/time])
  end

  test "ESI mode" do
    get "/", {}, {"QOR_CACHE_ESI_ENABLED" => 1}
    assert_response 200
    assert response.body.include?(%Q[<esi:include src="/qor_cache_includes/time])
  end

  test "request qor_cache_includes partial" do
    get "/qor_cache_includes/time"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/qor_cache_includes/time"
    assert_response 200
    assert response.body.include?('2012-10-10')

    get "/qor_cache_includes/time?hello"
    assert_response 200
    assert response.body.include?('2012-10-11')
  end

  test "no cache includes" do
    get "/nocache"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/nocache"
    assert_response 200
    assert response.body.include?('2012-10-11')
  end
end
