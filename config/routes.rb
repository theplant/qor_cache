Rails.application.routes.draw do
  match "/qor_cache_includes/*path" => "Qor::Cache#includes"
end
