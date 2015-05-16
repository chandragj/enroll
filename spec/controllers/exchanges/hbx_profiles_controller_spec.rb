require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe HbxProfilesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # HbxProfile. As you add validations to HbxProfile, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # HbxProfilesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all hbx_profiles as @hbx_profiles" do
      hbx_profile = HbxProfile.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:hbx_profiles)).to eq([hbx_profile])
    end
  end

  describe "GET show" do
    it "assigns the requested hbx_profile as @hbx_profile" do
      hbx_profile = HbxProfile.create! valid_attributes
      get :show, {:id => hbx_profile.to_param}, valid_session
      expect(assigns(:hbx_profile)).to eq(hbx_profile)
    end
  end

  describe "GET new" do
    it "assigns a new hbx_profile as @hbx_profile" do
      get :new, {}, valid_session
      expect(assigns(:hbx_profile)).to be_a_new(HbxProfile)
    end
  end

  describe "GET edit" do
    it "assigns the requested hbx_profile as @hbx_profile" do
      hbx_profile = HbxProfile.create! valid_attributes
      get :edit, {:id => hbx_profile.to_param}, valid_session
      expect(assigns(:hbx_profile)).to eq(hbx_profile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HbxProfile" do
        expect {
          post :create, {:hbx_profile => valid_attributes}, valid_session
        }.to change(HbxProfile, :count).by(1)
      end

      it "assigns a newly created hbx_profile as @hbx_profile" do
        post :create, {:hbx_profile => valid_attributes}, valid_session
        expect(assigns(:hbx_profile)).to be_a(HbxProfile)
        expect(assigns(:hbx_profile)).to be_persisted
      end

      it "redirects to the created hbx_profile" do
        post :create, {:hbx_profile => valid_attributes}, valid_session
        expect(response).to redirect_to(HbxProfile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved hbx_profile as @hbx_profile" do
        post :create, {:hbx_profile => invalid_attributes}, valid_session
        expect(assigns(:hbx_profile)).to be_a_new(HbxProfile)
      end

      it "re-renders the 'new' template" do
        post :create, {:hbx_profile => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested hbx_profile" do
        hbx_profile = HbxProfile.create! valid_attributes
        put :update, {:id => hbx_profile.to_param, :hbx_profile => new_attributes}, valid_session
        hbx_profile.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested hbx_profile as @hbx_profile" do
        hbx_profile = HbxProfile.create! valid_attributes
        put :update, {:id => hbx_profile.to_param, :hbx_profile => valid_attributes}, valid_session
        expect(assigns(:hbx_profile)).to eq(hbx_profile)
      end

      it "redirects to the hbx_profile" do
        hbx_profile = HbxProfile.create! valid_attributes
        put :update, {:id => hbx_profile.to_param, :hbx_profile => valid_attributes}, valid_session
        expect(response).to redirect_to(hbx_profile)
      end
    end

    describe "with invalid params" do
      it "assigns the hbx_profile as @hbx_profile" do
        hbx_profile = HbxProfile.create! valid_attributes
        put :update, {:id => hbx_profile.to_param, :hbx_profile => invalid_attributes}, valid_session
        expect(assigns(:hbx_profile)).to eq(hbx_profile)
      end

      it "re-renders the 'edit' template" do
        hbx_profile = HbxProfile.create! valid_attributes
        put :update, {:id => hbx_profile.to_param, :hbx_profile => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested hbx_profile" do
      hbx_profile = HbxProfile.create! valid_attributes
      expect {
        delete :destroy, {:id => hbx_profile.to_param}, valid_session
      }.to change(HbxProfile, :count).by(-1)
    end

    it "redirects to the hbx_profiles list" do
      hbx_profile = HbxProfile.create! valid_attributes
      delete :destroy, {:id => hbx_profile.to_param}, valid_session
      expect(response).to redirect_to(hbx_profiles_url)
    end
  end

end
