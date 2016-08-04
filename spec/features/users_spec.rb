require 'rails_helper'

RSpec.feature "Users", type: :feature do
  describe "Sign up" do
    context "with  valid parameters" do
      it "redirects to home page, shows users name and show a flash message" do
        visit new_user_path

        # save_and_open_page

        fill_in "First name", with: "Tam"
        fill_in "Last name", with: "Kbeili"
        fill_in "Email", with: "tam@codecore.ca"
        fill_in "Password", with: "supersecret"
        fill_in "Password confirmation", with: "supersecret"

        click_button "Create User"

        expect(current_path).to eq(root_path)
        expect(page).to have_text /Account successfully created/i
        user = User.last
        expect(page).to have_text /#{user.full_name}/i

      end
    end

  end
end
