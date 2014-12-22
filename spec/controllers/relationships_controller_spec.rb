require 'spec_helper'

describe RelationshipsController do 
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end 
    it "sets @relationships to the current user's following relationships" do 
      andy = Fabricate(:user)
      bob  = Fabricate(:user) 
      set_current_user(andy)
      relationship = Fabricate(:relationship, leader: bob, follower: andy)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end 
  end 

  describe "DELETE destroy" do 
    it_behaves_like "requires sign in" do 
      let(:action) {delete :destroy, id: 1}
    end 
    it "redirects to the people page" do 
      andy = Fabricate(:user)
      bob  = Fabricate(:user) 
      set_current_user(andy)
      relationship = Fabricate(:relationship, leader: bob, follower: andy)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end 
    it "deletes a relationship if the current user is a follower" do 
      andy = Fabricate(:user)
      bob  = Fabricate(:user) 
      set_current_user(andy)
      relationship = Fabricate(:relationship, leader: bob, follower: andy)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end 
    it "does not delete a relationship if the current user is not a follower" do 
      andy = Fabricate(:user)
      bob  = Fabricate(:user) 
      clara = Fabricate(:user)
      set_current_user(andy)
      relationship = Fabricate(:relationship, leader: bob, follower: clara)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end 
  end 

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create, leader_id: 2}
    end
    it "redirects to the people page" do 
      andy = Fabricate(:user)
      set_current_user(andy)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end 
    it "creates a relationship where the current user is the follower" do 
      andy = Fabricate(:user)
      set_current_user(andy)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(andy.following_relationships.first.leader).to eq(bob)
    end 
    it "does not create any relationship if the current user is already following the other user" do 
      andy = Fabricate(:user)
      set_current_user(andy)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: andy, leader: bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end 
    it "does not allow a user to follow him/herself" do 
      andy = Fabricate(:user)
      set_current_user(andy)
      post :create, leader_id: andy.id
      expect(Relationship.count).to eq(0)
    end 
  end 
end    