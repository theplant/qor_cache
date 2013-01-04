Dummy::Application.routes.draw do
  match "/" => "application#index"
  match "/nocache" => "application#nocache"
end
