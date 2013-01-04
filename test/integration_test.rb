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

  test "qor_cache_includes no_cache option" do
    get "/nocache"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/nocache"
    assert_response 200
    assert response.body.include?('2012-10-11')
  end

  test "qor_cache_includes expires_in option" do
    get "/expires_in"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/expires_in"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-13")
    get "/expires_in"
    assert_response 200
    assert response.body.include?('2012-10-13')
  end

  test "qor_cache_includes with qor_cache_key" do
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-10')

    FactoryGirl.create(:product)
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-11')

    Timecop.freeze("2012-10-12")
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-11')

    FactoryGirl.create(:color_variation)
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-12')

    Timecop.freeze("2012-10-13")
    get "/products"
    assert_response 200
    assert response.body.include?('2012-10-12')
  end

  test "qor_cache_includes with helpers current_user" do
    get "/helpers", {}, {"CURRENT_USER_ID" => 1}
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/helpers", {}, {"CURRENT_USER_ID" => 1}
    assert_response 200
    assert response.body.include?('2012-10-10')

    get "/helpers", {}, {"CURRENT_USER_ID" => 2}
    assert_response 200
    assert response.body.include?('2012-10-11')
  end

  test "qor_cache_includes with block" do
    FactoryGirl.create(:product)
    get "/with_block", {}, {"CURRENT_USER_ID" => 1}
    assert_response 200
    assert response.body.include?('2012-10-10')

    Timecop.freeze("2012-10-11")
    get "/with_block", {}, {"CURRENT_USER_ID" => 1}
    assert_response 200
    assert response.body.include?('2012-10-10')

    get "/with_block", {}, {"CURRENT_USER_ID" => 2}
    assert_response 200
    assert response.body.include?('2012-10-11')
  end
end
