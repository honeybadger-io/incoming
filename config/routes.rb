Mailkit::Engine.routes.draw do
  match '/emails/:receiver' => 'emails#create', via: :post
end