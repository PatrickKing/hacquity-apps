require "application_system_test_case"

class ServicePostingsTest < ApplicationSystemTestCase
  setup do
    @service_posting = service_postings(:one)
  end

  test "visiting the index" do
    visit service_postings_url
    assert_selector "h1", text: "Service Postings"
  end

  test "creating a Service posting" do
    visit service_postings_url
    click_on "New Service Posting"

    fill_in "Closed", with: @service_posting.closed
    fill_in "Description", with: @service_posting.description
    fill_in "Fulltimeequivalents", with: @service_posting.fullTimeEquivalents
    fill_in "Postingtype", with: @service_posting.postingType
    fill_in "Summary", with: @service_posting.summary
    fill_in "Userid", with: @service_posting.userId_id
    click_on "Create Service posting"

    assert_text "Service posting was successfully created"
    click_on "Back"
  end

  test "updating a Service posting" do
    visit service_postings_url
    click_on "Edit", match: :first

    fill_in "Closed", with: @service_posting.closed
    fill_in "Description", with: @service_posting.description
    fill_in "Fulltimeequivalents", with: @service_posting.fullTimeEquivalents
    fill_in "Postingtype", with: @service_posting.postingType
    fill_in "Summary", with: @service_posting.summary
    fill_in "Userid", with: @service_posting.userId_id
    click_on "Update Service posting"

    assert_text "Service posting was successfully updated"
    click_on "Back"
  end

  test "destroying a Service posting" do
    visit service_postings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Service posting was successfully destroyed"
  end
end
