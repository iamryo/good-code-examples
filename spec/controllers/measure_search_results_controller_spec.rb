require 'rails_helper'

RSpec.describe MeasureSearchResultsController do
  login_user

  save_fixture do
    get :index, term: 'readmission'
  end
end
