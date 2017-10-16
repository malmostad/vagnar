# CanCan requires a model class with load_and_authorize_resource
class Home; end

class HomeController < ApplicationController
  skip_before_action :authenticate
  skip_authorize_resource
  before_action { authorize! :view, :home }

  def index
  end
end
