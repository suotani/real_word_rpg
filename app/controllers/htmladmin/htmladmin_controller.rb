class Htmladmin::HtmladminController < ApplicationController
  
  before_action :authenticate_user!
end
