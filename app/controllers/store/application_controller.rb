class Store::ApplicationController < ApplicationController
  before_action :authenticate_user!
  layout 'store/application'
end
