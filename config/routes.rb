DummySsoApp::Application.routes.draw do
  scope "/waggl" do
    resource :sso, only: [:show, :create]
  end
end
