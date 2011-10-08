Dummy::Application.routes.draw do

  get "skip_xhr_request/index"

  get "fallbacks/index"

  get "testing" => "testing#index"

  get "home(.:format)"            => "home#index"
  get "respond_to_test(.:format)" => "home#respond_to_test"
  get "no_mobile_view(.:format)"  => "home#no_mobile_view"

  get "load_from_mobile_path"     => "view_path#index"
  get "ignore_mobile_path"        => "ignore_mobile_path#index"

  get "no_fallback/index(.:format)" => "no_fallback#index"
  get "no_fallback/test(.:format)"  => "no_fallback#test"

  get "default_fallback/index(.:format)"  => "default_fallback#index"
  get "default_fallback/test(.:format)"   => "default_fallback#test"

  get "force_fallback/index(.:format)"  => "force_fallback#index"
  get "force_fallback/test(.:format)"   => "force_fallback#test"

  root :to => "home#index"
end
