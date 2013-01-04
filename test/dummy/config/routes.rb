Dummy::Application.routes.draw do
  match "/" => "application#index"
  match "/nocache" => "application#nocache"
  match "/expires_in" => "application#expires_in"
  match "/products" => "application#products"
end
