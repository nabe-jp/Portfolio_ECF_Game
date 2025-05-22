class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
end