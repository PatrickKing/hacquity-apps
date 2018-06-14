require 'test_helper'

class MentorMatchProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mentor_match_profile = mentor_match_profiles(:one)
  end

  test "should get index" do
    get mentor_match_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_mentor_match_profile_url
    assert_response :success
  end

  test "should create mentor_match_profile" do
    assert_difference('MentorMatchProfile.count') do
      post mentor_match_profiles_url, params: { mentor_match_profile: { cv_text: @mentor_match_profile.cv_text, match_role: @mentor_match_profile.match_role, position: @mentor_match_profile.position, user_id: @mentor_match_profile.user_id } }
    end

    assert_redirected_to mentor_match_profile_url(MentorMatchProfile.last)
  end

  test "should show mentor_match_profile" do
    get mentor_match_profile_url(@mentor_match_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_mentor_match_profile_url(@mentor_match_profile)
    assert_response :success
  end

  test "should update mentor_match_profile" do
    patch mentor_match_profile_url(@mentor_match_profile), params: { mentor_match_profile: { cv_text: @mentor_match_profile.cv_text, match_role: @mentor_match_profile.match_role, position: @mentor_match_profile.position, user_id: @mentor_match_profile.user_id } }
    assert_redirected_to mentor_match_profile_url(@mentor_match_profile)
  end

  test "should destroy mentor_match_profile" do
    assert_difference('MentorMatchProfile.count', -1) do
      delete mentor_match_profile_url(@mentor_match_profile)
    end

    assert_redirected_to mentor_match_profiles_url
  end
end
