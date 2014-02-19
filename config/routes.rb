MBH::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'bitcents#index'

  # get 'buy-pixels/:x/:y/:width/:height' => 'bitcents#buy_pixels'
  get 'buy-pixels' => 'bitcents#buy_pixels', as: 'buy_pixels'
  post '/pay-pixels' => 'bitcents#pay_pixels', as: 'pay_pixels'
  get '/validate-rect' => 'bitcents#validate_rect', as: 'validate_rect'
  get '/do_payment/:ref_id/:amount' => 'bitcents#do_payment', as: 'do_payment'  
  #post '/bitcoin-callback' => 'bitcents#callback', as: 'bitcoin_callback'
  get '/thank-you' => 'bitcents#thank_you', as: 'thank_you'
  

  get '/bitcoin-callback' => 'bitcents#bitcoin_callback', as: 'bitcoin_callback'
  #post '/bitcoin-callback' => 'bitcents#bitcoin_callback'
  
  get '/test0123456789' => 'bitcents#check_database'

  resources :bitcents do 
    collection do
      post 'upload_file'
    end
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
