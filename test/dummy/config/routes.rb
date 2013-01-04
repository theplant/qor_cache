Dummy::Application.routes.draw do
  match "/" => "application#index"
  match "/nocache" => "application#nocache"
  match "/expires_in" => "application#expires_in"
  match "/products" => "application#products"
  match "/helpers" => "application#helpers"
  match "/with_block" => "application#with_block"
end
