require 'spec_helper'

class RolesUser
  include Lf::Roles
  possible_role "super"
  possible_role "admin"
  possible_role "normal"
  attr_accessor :roles_mask

  def initialize(roles)
    self.roles=roles
  end
end

describe Lf::Roles do
  it 'has a version number' do
    expect(Lf::Roles::VERSION).not_to be nil
  end

  describe "defining roles" do
    it "should contain the correct roles" do
      expect(RolesUser.possible_roles).to eq ["super", "admin", "normal"]
    end
  end




  describe "Checking roles" do
    let (:normal_user) {
      RolesUser.new(["normal"])
    }

    let (:admin_user) {
      RolesUser.new(["normal", "admin"])
    }

    describe "#is?" do
      context "class instance has the role in question" do
        it "should return true" do
          expect(normal_user.is?("normal")).to be_truthy
        end
      end
      context "class instance does not have the role in question" do
        it "should return false" do
          expect(normal_user.is?("super")).to be_falsey
        end
      end
    end

    describe "#is_only?" do
      context "class instance has the role in question and no others" do
        it "should return true" do
          expect(normal_user.is_only?("normal")).to be_truthy
        end
      end

      context "class instance has the role in question and others" do
        it "should return false" do
          expect(admin_user.is_only?("admin")).to be_falsey
        end
      end

      context "class instance does not have the role in question" do
        it "should return false" do
          expect(admin_user.is_only?("super")).to be_falsey
        end
      end
    end
  end
end
