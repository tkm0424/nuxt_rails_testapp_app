class ApplicationController < ActionController::API
  #Cookieを扱う
  include ActionController::Cookies
  #認可を扱う
  include UserAuthenticateService
end
