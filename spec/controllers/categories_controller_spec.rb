require 'spec_helper'

describe CategoriesController do 
  describe "GET index" do 
    it 'sets @categories variable' do 
      comedies = Category.create(name: "Comedies")
      dramas = Category.create(name: "Dramas")
      get :index 
      expect(assigns(:categories)).to eq([comedies, dramas])
    end 
    it 'renders the index template' do 
      get :index 
      expect(response).to render_template :index 
    end 
  end 

  describe "GET show" do 
    it 'sets @category variable' do 
      category = Category.create(name: "Comedies")
      get :show, id: category.id
      expect(assigns(:category)).to eq(category)
    end 
  end 
end 