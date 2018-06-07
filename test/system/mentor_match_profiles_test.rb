require "application_system_test_case"

class MentorMatchProfilesTest < ApplicationSystemTestCase
  setup do
    @mentor_match_profile = mentor_match_profiles(:one)
  end

  test "visiting the index" do
    visit mentor_match_profiles_url
    assert_selector "h1", text: "Mentor Match Profiles"
  end

  test "creating a Mentor match profile" do
    visit mentor_match_profiles_url
    click_on "New Mentor Match Profile"

    fill_in "Cv Text", with: @mentor_match_profile.cv_text
    fill_in "Match Role", with: @mentor_match_profile.match_role
    fill_in "Position", with: @mentor_match_profile.position
    fill_in "User", with: @mentor_match_profile.user_id
    click_on "Create Mentor match profile"

    assert_text "Mentor match profile was successfully created"
    click_on "Back"
  end

  test "updating a Mentor match profile" do
    visit mentor_match_profiles_url
    click_on "Edit", match: :first

    fill_in "Cv Text", with: @mentor_match_profile.cv_text
    fill_in "Match Role", with: @mentor_match_profile.match_role
    fill_in "Position", with: @mentor_match_profile.position
    fill_in "User", with: @mentor_match_profile.user_id
    click_on "Update Mentor match profile"

    assert_text "Mentor match profile was successfully updated"
    click_on "Back"
  end

  test "destroying a Mentor match profile" do
    visit mentor_match_profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mentor match profile was successfully destroyed"
  end
end
